defmodule MyApp.Concert do
  use Ecto.Schema

  import Ecto.Changeset

  schema "concerts" do
    field :name, :string
    many_to_many :artists, MyApp.Artist, join_through: "concerts_artists"
  end

  def changeset(concert, params \\ %{}) do
    concert
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
