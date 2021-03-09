defmodule AddressGeneratorTest do
  use ExUnit.Case

  test "generate and valid address" do
    type = :p2pkh
    {ret, {private_key, address}} = AddressGenerator.generate_address(type)
    assert ret == :ok
    assert true == AddressGenerator.address_valid?(address, type)

    {ret, {_, address}} = AddressGenerator.generate_address(private_key, type)
    assert ret == :ok
    assert true == AddressGenerator.address_valid?(address, type)

    type = :p2sh
    {ret, {private_key, address}} = AddressGenerator.generate_address(type)
    assert ret == :ok
    assert true == AddressGenerator.address_valid?(address, type)

    {ret, {_, address}} = AddressGenerator.generate_address(private_key, type)
    assert ret == :ok
    assert true == AddressGenerator.address_valid?(address, type)
  end
end
