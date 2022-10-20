defmodule BlogApi.CommentView do
  use BlogApi, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, __MODULE__, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, BlogApi.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      description: comment.description
    }
  end

  def render("errors.json", %{errors: errors}), do: %{success: false, errors: errors}
  def render("error.json", %{error: error}), do: %{success: false, error: error}
end
