defmodule Bookmark.Shortcode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shortcodes" do
    field :code, :string
    field :title, :string
    field :url, :string
    field :created_by, :integer

    timestamps()
  end

  @doc false
  def changeset(shortcode, attrs) do
    shortcode
    |> cast(attrs, [:code, :url, :created_by])
    |> validate_required([:code, :url, :created_by])
  end
end
