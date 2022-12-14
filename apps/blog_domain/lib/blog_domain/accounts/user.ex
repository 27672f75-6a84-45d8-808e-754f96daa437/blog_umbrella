defmodule BlogDomain.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @table "users"

  schema @table do
    field(:user_email, :string)
    field(:user_name, :string)
    field(:password, :string, [{:virtual, true}])
    field(:password_hash, :string)

    has_many(:posts, BlogDomain.Boards.Post)
    has_many(:comments, BlogDomain.Boards.Comment)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_email, :user_name, :password])
    |> cast_assoc(:posts)
    |> cast_assoc(:comments)
    |> validate_length(:user_name, [{:min, 3}, {:max, 64}])
    |> validate_length(:password, [{:min, 8}, {:max, 128}])
    |> put_password_hash()
    |> validate_required([:user_email, :user_name, :password_hash])
    |> unique_constraint([:user_email])
  end

  def login_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_email, :password])
    |> validate_length(:password, [{:min, 8}, {:max, 128}])
    |> put_password_hash()
    |> validate_required([:user_email, :password_hash])
  end

  def user_id_query(query, user_id) do
    from(q in query, [{:where, q.user_id == ^user_id}])
  end

  def user_email_query(query, user_email) do
    from(q in query, [{:where, q.user_email == ^user_email}])
  end

  def user_lock_query(query) do
    from(q in query, [{:lock, "FOR UPDATE"}])
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
