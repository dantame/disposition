defmodule Disposition.SentimentTest do
  use Disposition.ModelCase

  alias Disposition.Sentiment

  @valid_attrs %{actor: "some content", metadata: %{}, origin: "some content", sentiment: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Sentiment.changeset(%Sentiment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Sentiment.changeset(%Sentiment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
