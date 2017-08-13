defmodule MyApp.Album do
  use Ecto.Schema

  import Ecto.Changeset

  schema "albums" do
    field :name, :string
    many_to_many :artists, MyApp.Artist, join_through: "albums_artists"
  end

  def changeset(album, params \\ %{}) do
    album
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
