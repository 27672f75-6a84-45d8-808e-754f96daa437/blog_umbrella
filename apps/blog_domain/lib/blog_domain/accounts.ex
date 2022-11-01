defmodule BlogDomain.Accounts do
  alias BlogDomain.Repo
  alias BlogDomain.Accounts.User

  def create_user(params \\ %{}) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def get_user(id), do: Repo.get(User, id)

  def authenticate_by_username_and_pass(user_email, password) do
    user = get_user_by_user_email(user_email)

    cond do
      user && Argon2.verify_pass(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Argon2.no_user_verify()
        {:error, :not_found}
    end
  end

  def update_user(%User{id: id}, params \\ %{}) do
    fn ->
      case get_user_lock(id) do
        %User{} = user -> User.changeset(user, params) |> Repo.update()
        nil -> {:error, :not_found}
      end
    end
    |> Repo.transaction()
  end

  def user_list(), do: Repo.all(User)

  defp get_user_lock(id) do
    User
    |> User.user_lock_query()
    |> Repo.get(id)
  end

  defp get_user_by_user_email(user_email) do
    User
    |> User.user_email_query(user_email)
    |> Repo.one()
  end
end
