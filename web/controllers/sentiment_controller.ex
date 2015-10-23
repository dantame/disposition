defmodule Disposition.SentimentController do
  use Disposition.Web, :controller

  alias Disposition.Sentiment

  plug :scrub_params, "sentiment" when action in [:create, :update]

  def index(conn, _params) do
    sentiments = Repo.all(Sentiment)

    analyzed_sentiments = Enum.map(sentiments, fn(record) ->
      Map.merge(record, %{score: Sentient.analyze(record.sentiment)})
    end)

    render(conn, "index.json", sentiments: analyzed_sentiments)
  end

  def create(conn, sentiment_params) do
    changeset = Sentiment.changeset(%Sentiment{}, sentiment_params)

    case Repo.insert(changeset) do
      {:ok, sentiment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", sentiment_path(conn, :show, sentiment))
        |> render("sentiment.json", sentiment: sentiment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Disposition.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sentiment = Repo.get!(Sentiment, id)
    analyzed_sentiment = Map.merge(sentiment, %{score: Sentient.analyze(sentiment.sentiment)})
    render(conn, "show.json", sentiment: analyzed_sentiment)
  end

  def update(conn, %{"id" => id, "sentiment" => sentiment_params}) do
    sentiment = Repo.get!(Sentiment, id)
    changeset = Sentiment.changeset(sentiment, sentiment_params)

    case Repo.update(changeset) do
      {:ok, sentiment} ->
        render(conn, "show.json", sentiment: sentiment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Disposition.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sentiment = Repo.get!(Sentiment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(sentiment)

    send_resp(conn, :no_content, "")
  end
end
