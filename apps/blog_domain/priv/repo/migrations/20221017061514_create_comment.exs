defmodule BlogDomain.Repo.Migrations.CreateComment do
  use Ecto.Migration

  @table "comments"

  def change do
    create table(@table) do
      add(:description, :text, [{:null, false}])
      add :user_id, references(:users, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, :user_id)
    create index(:comments, :post_id)
  end
end