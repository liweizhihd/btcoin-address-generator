defmodule Base58Check do
  @moduledoc """
  `Base58Check` provides one function: `encode/2`.
  `encode/2` takes two **Elixir binary** (data and version)
  """

  def encode(data, version) do
    Base58.encode(version <> data <> checksum(data, version))
  end

  defp checksum(data, version) do
    (version <> data)
    |> sha256
    |> sha256
    |> split
  end

  defp split(<<hash :: bytes - size(4), _ :: bits>>) do
    hash
  end

  defp sha256(data) do
    :crypto.hash(:sha256, data)
  end
end