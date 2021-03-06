defmodule Netgag.Gag do
  use Netgag.Web, :model

  schema "gags" do
    field :slug, :string
    field :section, :string
    field :page, :string
    field :meme, :string
    has_many :comments, Netgag.Comment

    timestamps
  end

  @required_fields ~w(section)
  @optional_fields ~w(slug page meme)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> add_slug
  end

  defp add_slug(changeset) do
    if changeset.model.slug == nil do
      put_change(changeset, :slug, generate_slug)
    else
      changeset
    end
  end

  defp generate_slug do
    UUID.uuid4()
  end

  defimpl Phoenix.Param, for: Netgag.Gag do
    def to_param(%{slug: slug}) do
      slug
    end
  end
end
