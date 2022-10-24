defmodule BlogApi.AuthControllerTest do
  use BlogApi.ConnCase, async: true

  alias BlogDomain.Accounts.User

  @valid_params %{
    user_name: "User",
    user_email: "User Email",
    password: "supersecret"
  }

  test "POST /register", %{conn: conn} do
    conn = post(conn, Routes.auth_path(conn, :register), @valid_params)

    assert %{"data" => %{"user_email" => "User Email", "user_name" => "User", "token" => _token}} =
             json_response(conn, 201)
  end

  test "POST /login", %{conn: conn} do
    %User{user_email: user_email, password: password} = user_fixture(@valid_params)

    conn =
      post(conn, Routes.auth_path(conn, :login), %{
        "user_email" => user_email,
        "password" => password
      })

    assert %{"data" => %{"user_email" => "User Email", "user_name" => "User", "token" => _token}} =
             json_response(conn, 200)
  end

  test "POST /login again", %{conn: conn} do
    %User{user_email: user_email, password: password} = user_fixture(@valid_params)

    conn =
      post(conn, Routes.auth_path(conn, :login), %{
        "user_email" => user_email,
        "password" => password
      })

    conn =
      post(conn, Routes.auth_path(conn, :login), %{
        "user_email" => user_email,
        "password" => password
      })

    assert %{"errors" => "user already login", "success" => false} = json_response(conn, 400)
  end

  test "POST /logout", %{conn: conn} do
    %User{user_email: user_email, password: password} = user_fixture(@valid_params)

    conn =
      post(conn, Routes.auth_path(conn, :login), %{
        "user_email" => user_email,
        "password" => password
      })

    conn = post(conn, Routes.auth_path(conn, :logout))

    assert %{"data" => %{"token" => nil, "user_email" => "User Email", "user_name" => "User"}} =
             json_response(conn, 200)
  end
end
