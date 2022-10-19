defmodule BlogDomain.Boards do
  alias BlogDomain.Repo

  alias BlogDomain.Accounts
  alias BlogDomain.Accounts.User
  alias BlogDomain.Boards.{Post, Comment}

  def create_post(%User{} = user, params \\ %{}) do
    %Post{user_id: user.id}
    |> Post.changeset(params)
    |> Repo.insert()
  end

  def get_post(id), do: Repo.get(Post, id)

  def get_user_post(%User{id: user_id}, post_id, opts \\ []) do
    Post
    |> User.user_id_query(user_id)
    |> Repo.get(post_id, opts)
  end

  def get_user_post_lock(%User{} = user, post_id) do
    get_user_post(user, post_id, lock: "FOR UPDATE")
  end

  def list_user_posts(%User{id: user_id}) do
    Post
    |> User.user_id_query(user_id)
    |> Repo.all()
  end

  def update_user_post(%User{} = user, post_id, params \\ %{}) do
    fn ->
      case get_user_post_lock(user, post_id) do
        %Post{} = post -> Post.changeset(post, params) |> Repo.update()
        nil -> {:error, :not_found}
      end
    end
    |> Repo.transaction()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def write_comment(%Accounts.User{id: user_id, user_name: user_name}, post_id, params \\ %{}) do
    %Comment{user_id: user_id, post_id: post_id}
    |> Comment.changeset(Map.put(params, :user_name, user_name))
    |> Repo.insert()
  end

  def get_comment(id), do: Repo.get(Comment, id)

  def get_user_comment(%User{id: user_id}, comment_id, opts \\ []) do
    Comment
    |> User.user_id_query(user_id)
    |> Repo.get(comment_id, opts)
  end

  def get_user_comment_lock(%User{} = user, comment_id) do
    get_user_comment(user, comment_id, lock: "FOR UPDATE")
  end

  def get_user_post_all_comments(%User{} = user, post_id) do
    post =
      get_user_post(user, post_id)
      |> Repo.preload(:comments)

    post.comments
  end

  def get_post_user_comments(post_id, user_id) do
    post =
      get_post(post_id)
      |> Repo.preload(comments: Comment.comment_user_id(user_id))

    post.comments
  end

  def list_user_comments(%User{id: user_id}) do
    Comment
    |> User.user_id_query(user_id)
    |> Repo.all()
  end

  def list_post_comments(%Post{id: post_id}) do
    Comment
    |> Post.post_id_query(post_id)
    |> Repo.all()
  end

  def update_post_comment(%User{} = user, comment_id, params \\ %{}) do
    fn ->
      case get_user_comment_lock(user, comment_id) do
        %Comment{} = comment -> Comment.changeset(comment, params) |> Repo.update()
        nil -> {:error, :not_found}
      end
    end
    |> Repo.transaction()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end
end