defmodule Disposition.SentimentView do
  use Disposition.Web, :view

  def render("index.json", %{sentiments: sentiments}) do
    render_many(sentiments, Disposition.SentimentView, "analyzed_sentiment.json")
  end

  def render("show.json", %{sentiment: sentiment}) do
    render_one(sentiment, Disposition.SentimentView, "analyzed_sentiment.json")
  end

  def render("sentiment.json", %{sentiment: sentiment}) do
    %{id: sentiment.id,
      origin: sentiment.origin,
      sentiment: sentiment.sentiment,
      actor: sentiment.actor,
      metadata: sentiment.metadata}
  end

  def render("analyzed_sentiment.json", %{sentiment: sentiment}) do
    rendered = render("sentiment.json", %{sentiment: sentiment})

    Map.merge(rendered, %{score: sentiment.score})
  end
end
