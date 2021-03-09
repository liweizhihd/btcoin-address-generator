defmodule Bitcoin.AddressGenerator.Behaviour do
  @moduledoc false

  @callback generate_address(type :: atom()) ::
    {:ok, {privkey :: binary(), address :: String.t()}} | {:error, atom()}
  @callback generate_address(privkey :: binary(), type :: atom()) ::
   {:ok, {privkey :: binary(), address :: String.t()}} | {:error, atom()}
  @callback address_valid?(address :: String.t(), type :: atom()) :: true | false
end