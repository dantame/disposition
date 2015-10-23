defmodule Disposition.ErrorView do
  use Disposition.Web, :view

  def render("404.json", _assigns) do
    %{error: "Not found", code: 404}
  end

  def render("500.json", _assigns) do
    %{error: "Server internal error", code: 500}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
