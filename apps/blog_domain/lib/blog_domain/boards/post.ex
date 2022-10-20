defmodule BlogDomain.Boards.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @table "posts"

  schema @table do
    field(:title, :string)
    field(:description, :string)

    belongs_to(:user, BlogDomain.Accounts.User)
    has_many(:comments, BlogDomain.Boards.Comment)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :user_id])
    |> cast_assoc(:user)
    |> cast_assoc(:comments)
    |> validate_required([:title])
    |> foreign_key_constraint(:user_id)
  end

  def post_id_query(query, post_id) do
    from(q in query, [{:where, q.post_id == ^post_id}])
  end

  def get_post_join_user_comments_query(query, post_id, user_id) do
    from(q in query, [
      {:where, q.id == ^post_id},
      {:join, c in assoc(q, :comments)},
      {:where, c.user_id == ^user_id},
      {:select, c}
    ])
  end

  def get_all_comments_in_post_query(query, post_id) do
    from(q in query, [
      {:where, q.id == ^post_id},
      {:join, c in assoc(q, :comments)},
      {:select, c}
    ])
  end

  def get_comment_in_post_query(query, post_id, comment_id) do
    from(q in query, [
      {:where, q.id == ^post_id},
      {:join, c in assoc(q, :comments)},
      {:where, c.id == ^comment_id},
      {:select, c}
    ])
  end

  def post_lock_query(query) do
    from(q in query, [{:lock, "FOR UPDATE"}])
  end
end
