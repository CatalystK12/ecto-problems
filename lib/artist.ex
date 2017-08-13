defmodule MyApp.Artist do
  use Ecto.Schema

  import Ecto.Changeset

  schema "artists" do
    field :name, :string

    many_to_many :albums,    MyApp.Album,    join_through: "albums_artists"
    many_to_many :concerts,  MyApp.Concert,  join_through: "concerts_artists"
  end

  def changeset(artist, params=%{albums: _albums}) do
    artist
    |> cast(params, [:name])
    |> validate_required([:name])
    |> put_assoc(:albums, params[:albums])
  end
  def changeset(artist, params=%{concerts: _concerts}) do
    artist
    |> cast(params, [:name])
    |> validate_required([:name])
    |> put_assoc(:concerts, params[:concerts])
  end
  def changeset(artist, params=%{name: _name}) do
    artist
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
