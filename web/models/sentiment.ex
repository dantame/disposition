defmodule Disposition.Sentiment do
  use Disposition.Web, :model

  schema "sentiments" do
    field :origin, :string
    field :sentiment, :string
    field :actor, :string
    field :metadata, :map

    timestamps
  end

  @required_fields ~w(origin sentiment actor)
  @optional_fields ~w(metadata)

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
