defmodule BlogApi.PostView do
  use BlogApi, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, __MODULE__, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, BlogApi.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{
      title: post.title,
      description: post.description
    }
  end

  def render("errors.json", %{errors: errors}), do: %{success: false, errors: errors}
  def render("error.json", %{error: error}), do: %{success: false, error: error}
end
