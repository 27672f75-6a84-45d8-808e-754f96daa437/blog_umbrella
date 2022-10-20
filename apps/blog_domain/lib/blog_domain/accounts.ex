defmodule BlogDomain.Accounts do
  alias BlogDomain.Repo
  alias BlogDomain.Accounts.User

  def create_user(params \\ %{}) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def get_user(id), do: Repo.get(User, id)

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
end
