defmodule BlogClientMintTest do
  use ExUnit.Case
  doctest BlogClientMint

  test "greets the world" do
    assert BlogClientMint.hello() == :world
  end
end
