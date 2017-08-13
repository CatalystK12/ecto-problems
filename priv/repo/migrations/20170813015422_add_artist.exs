defmodule MyApp.Repo.Migrations.AddArtist do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :name, :text
    end

    create table(:albums) do
      add :name, :text
    end

    create table(:concerts) do
      add :name, :text
    end

    create table(:albums_artists, primary_key: false) do
      add :artist_id, references(:artists)
      add :album_id, references(:albums)
    end

    create table(:concerts_artists, primary_key: false) do
      add :artist_id, references(:artists)
      add :concert_id, references(:concerts)
    end
  end
end
