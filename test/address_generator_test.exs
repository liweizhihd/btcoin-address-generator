defmodule AddressGeneratorTest do
  use ExUnit.Case

  test "self generate and valid address" do
    type = :p2pkh
    {ret, {private_key, address}} = AddressGenerator.generate_address(type)
    assert ret == :ok
    assert AddressGenerator.address_valid?(address, type) == true

    {ret, {_, address}} = AddressGenerator.generate_address(private_key, type)
    assert ret == :ok
    assert AddressGenerator.address_valid?(address, type) == true

    type = :p2sh
    {ret, {private_key, address}} = AddressGenerator.generate_address(type)
    assert ret == :ok
    assert AddressGenerator.address_valid?(address, type) == true

    {ret, {_, address}} = AddressGenerator.generate_address(private_key, type)
    assert ret == :ok
    assert AddressGenerator.address_valid?(address, type) == true
  end

  test "test address_valid with addresses from internet" do
    addresses_p2pkh = [
      "1527KSQWz2Dy23TnwgBww8GQmBtgScegGA",
      "1BpPBzKafLt8b7xhD4PXR2zdTAxoREamtb",
      "1JSRadi9rsXVzKdSDapwV4mTS4VEH7NYL7",
      "15gECsVkA81Gdr3UZHFt8u3NrhViqmGnQG",
      "1GR9cCrTpzRjUWGmXvXRXHGqDkFmQSkWe7",
      "14xmkm4PQ1aG8e1m5nZ8fFej6scW93HGBF",
      "14aMfqXZGduqpb98hZykocYfFDuciBdWKY",
      "1527KSQWz2Dy23TnwgBww8GQmBtgScegGA",
      "13jHKu7EpUhhdfv24e4mq8Tge3XVe9XKxW",
      "1LxRZZfp6E1GE6186Zbi1xHgdZSWpx4gyJ",
      "1NdqsVP87fu7qRqizsis6xhu5JcyvAyfLC"
    ]
    for address <- addresses_p2pkh do
      assert AddressGenerator.address_valid?(address, :p2pkh) == true
    end

    addresses_p2sh = [
      "3G2UncLtqKRATeSFiBf3JByC8LDrTfaTMN",
      "39mCGrShu3xuMdwA135vMtnjyRLxyasDXH",
      "3HX95NdyNde7d4Zm3nsEsKTvWuoq3YUhk9",
      "34dDKqPSRZQTeyAWMk1TuYGAcwS7YDJqRn",
      "3PLe29apPBhgRQWgf3hdyiKsneAU5jxt5D",
      "3BpMs1wVRdDY6wYXBMHvLDyNzAQtDY419U",
      "3ETpLFf7Jg5UdBtiU7h1MN5zy4M38vFiCi",
      "3FMnkhxPrnRUGEEoXtV6BeTehJQEQnfhxV",
      "3QNFNwHPpsyioVCmCPKxsYevfBVNr8PE43"
    ]
    for address <- addresses_p2sh do
      assert AddressGenerator.address_valid?(address, :p2sh) == true
    end
  end
end
