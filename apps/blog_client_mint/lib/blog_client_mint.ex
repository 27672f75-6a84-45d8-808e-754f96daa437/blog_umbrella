defmodule BlogClientMint do
  def http_request(method, url, header, body) do
    {:ok, conn} = connect()
    {:ok, conn, request_ref} = Mint.HTTP.request(conn, method, url, header, body)

    receive do
      message ->
        {:ok, conn, responses} = Mint.HTTP.stream(conn, message)

        for response <- responses do
          handle_response()
        end

        Mint.HTTP.close(conn)
    end
  end

  defp connect() do
    {:ok, conn} = Mint.HTTP.connect(:http, "localhost", 4000)
  end

  defp handle_response(response) do
    case response do
      {:status, ^request_ref, status_code} ->
        IO.puts("Status: #{status_code}")

      {:headers, ^request_ref, headers} ->
        IO.puts("> Response headers: #{inspect(headers)}")

      {:data, ^request_ref, data} ->
        IO.puts("> Response body")
        IO.puts(data)

      {:done, ^request_ref} ->
        IO.puts("> Response fully received")
    end
  end
end
