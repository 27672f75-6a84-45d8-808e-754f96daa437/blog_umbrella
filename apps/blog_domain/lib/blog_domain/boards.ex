defmodule BlogDomain.Boards do
  alias BlogDomain.Repo

  alias BlogDomain.Accounts.User
  alias BlogDomain.Boards.{Post, Comment}

  def create_post(%User{id: user_id}, params \\ %{}) do
    %Post{user_id: user_id}
    |> Post.changeset(params)
    |> Repo.insert()
  end

  def get_post(id), do: Repo.get(Post, id)

  def get_post_lock(post_id) do
    Post
    |> Post.post_lock_query()
    |> Repo.get(post_id)
  end

  def post_list() do
    Post
    |> Repo.all()
  end

  def update_post(post_id, params \\ %{}) do
    fn ->
      case get_post_lock(post_id) do
        %Post{} = post -> Post.changeset(post, params) |> Repo.update()
        nil -> {:error, :not_found}
      end
    end
    |> Repo.transaction()
  end

  def delete_post(%Post{} = post), do: Repo.delete(post)

  def write_comment(%User{id: user_id}, post_id, params \\ %{}) do
    %Comment{user_id: user_id, post_id: post_id}
    |> Comment.changeset(params)
    |> Repo.insert()
  end

  def get_post_comment(post_id, comment_id) do
    Post
    |> Post.get_comment_in_post_query(post_id, comment_id)
    |> Repo.one()
  end

  def list_post_comments(post_id) do
    Comment
    |> Post.post_id_query(post_id)
    |> Repo.all()
  end

  def update_post_comment(%User{} = user, post_id, comment_id, params \\ %{}) do
    fn ->
      case get_user_post_comment_lock(user, post_id, comment_id) do
        %Comment{} = comment -> Comment.changeset(comment, params) |> Repo.update()
        nil -> {:error, :not_found}
      end
    end
    |> Repo.transaction()
  end

  def delete_comment(%Comment{} = comment), do: Repo.delete(comment)

  defp get_user_post_comment_lock(%User{id: user_id}, post_id, comment_id) do
    Comment
    |> User.user_id_query(user_id)
    |> Post.post_id_query(post_id)
    |> Comment.comment_lock_query()
    |> Repo.get(comment_id)
  end
end
