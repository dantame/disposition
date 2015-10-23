defmodule Disposition.SentimentControllerTest do
  use Disposition.ConnCase

  alias Disposition.Sentiment
  @valid_attrs %{actor: "some content", metadata: %{}, origin: "some content", sentiment: "some good love content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, sentiment_path(conn, :index)
    assert json_response(conn, 200) == []
  end

  test "shows chosen resource", %{conn: conn} do
    sentiment = Repo.insert! %Sentiment{actor: @valid_attrs.actor, origin: @valid_attrs.origin, sentiment: @valid_attrs.sentiment}
    conn = get conn, sentiment_path(conn, :show, sentiment.id)

    analyzed_sentiment = Sentient.analyze(sentiment.sentiment)

    assert json_response(conn, 200) == %{"id" => sentiment.id,
      "origin" => sentiment.origin,
      "sentiment" => sentiment.sentiment,
      "actor" => sentiment.actor,
      "metadata" => sentiment.metadata,
      "score" =>  analyzed_sentiment}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, sentiment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, sentiment_path(conn, :create), @valid_attrs
    assert json_response(conn, 201)["id"]
    assert Repo.get_by(Sentiment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, sentiment_path(conn, :create), sentiment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    sentiment = Repo.insert! %Sentiment{}
    conn = put conn, sentiment_path(conn, :update, sentiment), sentiment: @valid_attrs
    assert json_response(conn, 200)["id"]
    assert Repo.get_by(Sentiment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    sentiment = Repo.insert! %Sentiment{}
    conn = put conn, sentiment_path(conn, :update, sentiment), sentiment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    sentiment = Repo.insert! %Sentiment{}
    conn = delete conn, sentiment_path(conn, :delete, sentiment)
    assert response(conn, 204)
    refute Repo.get(Sentiment, sentiment.id)
  end
end
