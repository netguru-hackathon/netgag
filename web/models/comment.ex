defmodule Netgag.Comment do
  use Netgag.Web, :model

  schema "comments" do
    field :body, :string
    field :user, :string
    belongs_to :gag, Netgag.Gag

    timestamps
  end

  @required_fields ~w(body user)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
