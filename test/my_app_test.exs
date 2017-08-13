defmodule MyAppTest do
  use ExUnit.Case
  doctest MyApp

  import Ecto.Query

  alias MyApp.{Repo,Album,Artist,Concert}

  defp get_artist_at_concert(artist_id, concert_id) do
    Repo.one from a in Artist,
      left_join: albums in assoc(a, :albums),
      join:      concerts in assoc(a, :concerts),
      where:     a.id == ^artist_id and concerts.id == ^concert_id,
      preload:   [albums: albums],
      order_by:  [a.id, albums.id]
  end

  # This fails in my real project, but is fine here.
  test "preload with empty left join" do
    {:ok, created_artist=%Artist{}} = Repo.insert(Artist.changeset(%Artist{}, %{name: "my artist"}))
    {:ok, concert=%Concert{}} = Repo.insert(Concert.changeset(%Concert{}, %{name: "BEST CONCERT EVER"}))

    artist = Repo.one from a in Artist, where: a.id == ^created_artist.id, preload: :concerts
    {:ok, artist} =
      artist
      |> Artist.changeset(%{concerts: [concert]})
      |> Repo.update()

    artist = get_artist_at_concert(created_artist.id, concert.id)

    assert created_artist.id == artist.id
    assert [] = artist.albums
  end

  # This works as expected. 
  test "preload with records returned in left join" do
    {:ok, created_artist=%Artist{}} = Repo.insert(Artist.changeset(%Artist{}, %{name: "my artist"}))
    {:ok, album=%Album{}} = Repo.insert(Album.changeset(%Album{}, %{name: "first album"}))
    {:ok, concert=%Concert{}} = Repo.insert(Concert.changeset(%Concert{}, %{name: "BEST CONCERT EVER"}))

    artist = Repo.one from a in Artist, where: a.id == ^created_artist.id, preload: :concerts
    {:ok, artist} =
      artist
      |> Artist.changeset(%{concerts: [concert]})
      |> Repo.update()

    artist = Repo.one from a in Artist, where: a.id == ^created_artist.id, preload: :albums
    {:ok, artist} =
      artist
      |> Artist.changeset(%{albums: [album]})
      |> Repo.update()

    artist = get_artist_at_concert(created_artist.id, concert.id)

    assert created_artist.id == artist.id
    assert [%Album{}] = artist.albums
  end

end
