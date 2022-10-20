defmodule BlogApi.UserControllerTest do
  use BlogApi.ConnCase, async: true

  alias BlogDomain.Accounts.User

  @valid_params %{
    user_name: "User",
    user_email: "User Email",
    password: "supersecret"
  }

  test "GET /users", %{conn: conn} do
    Enum.map(1..5, fn num ->
      user_fixture(%{
        user_name: @valid_params.user_name <> "#{num}",
        user_email: @valid_params.user_email <> "#{num}",
        password: @valid_params.password <> "#{num}"
      })
    end)

    conn = get(conn, Routes.user_path(conn, :index))

    assert %{
             "data" => [
               %{"user_email" => "User Email1", "user_name" => "User1"},
               %{"user_email" => "User Email2", "user_name" => "User2"},
               %{"user_email" => "User Email3", "user_name" => "User3"},
               %{"user_email" => "User Email4", "user_name" => "User4"},
               %{"user_email" => "User Email5", "user_name" => "User5"}
             ]
           } == json_response(conn, 200)
  end

  test "GET /users/:id", %{conn: conn} do
    %User{id: user_id} = user_fixture(@valid_params)

    conn = get(conn, Routes.user_path(conn, :show, user_id))

    assert %{"data" => %{"user_email" => "User Email", "user_name" => "User"}} =
             json_response(conn, 200)
  end

  test "POST /register", %{conn: conn} do
    conn = post(conn, Routes.user_path(conn, :register), @valid_params)

    assert %{"data" => %{"user_email" => "User Email", "user_name" => "User"}} =
             json_response(conn, 201)
  end

  test "UPDATE /users/:id", %{conn: conn} do
    %User{id: id} = user_fixture(@valid_params)

    conn =
      put(
        conn,
        Routes.user_path(conn, :update, id, %{
          "user_email" => "New Email",
          "user_name" => "New User"
        })
      )

    assert %{"data" => %{"user_email" => "New Email", "user_name" => "New User"}} ==
             json_response(conn, 200)
  end
end
