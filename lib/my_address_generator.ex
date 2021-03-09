defmodule AddressGenerator do
  @moduledoc """
  AddressGenerator provides three functions: `generate_address/1`, `generate_address/2` and `address_valid/2`.
  It can generate and validate Bitcoin's two kinds of addresses(P2PKH,P2SH).  

  reference:  
  1. https://medium.com/coinmonks/how-to-generate-a-bitcoin-address-step-by-step-9d7fcbf1ad0b
  2. http://www.petecorey.com/blog/2018/01/22/generating-bitcoin-private-keys-and-public-addresses-with-elixir/
  3. https://blog.lelonek.me/how-to-calculate-bitcoin-address-in-elixir-68939af4f0e9
  4. https://github.com/dwyl/base58/blob/master/lib/base58.ex [decode function will miss the starting "1"s in "1xxx", so a put several <<0x00>> at head]
  5. https://rosettacode.org/wiki/Bitcoin/address_validation
  6. https://www.tutorialspoint.com/elixir/elixir_loops.htm
  """

  @behaviour Bitcoin.AddressGenerator.Behaviour

  @doc """
  generate privateKey and address,return {:ok, {privkey :: binary(), address :: String.t()}} | {:error, atom()} 
  type = :p2pkh | :p2sh
  ## Examples

      iex(3)> AddressGenerator.generate_address(:p2pkh)
      {:ok,
       {<<74, 194, 89, 189, 160, 160, 203, 1, 54, 191, 82, 87, 194, 12, 30, 173, 35,11, 33, 149, 159, 21, 71, 191, 193, 245, 182, 193, 132, 88, 201, 118>>,
        "1CcYP7Sz4T1xU3XLju8FW8riBdGgZknQ1m"}}
  """
  def generate_address(type) do
    if type == :p2pkh || type == :p2sh do
      {publickey, privkey} = :crypto.generate_key(:ecdh, :secp256k1)
      generate_address_common(publickey, privkey, type)
    else
      {:error, :invalid_type}
    end
  end

  @doc """
  generate address depend on your private key,return {:ok, {privkey :: binary(), address :: String.t()}} | {:error, atom()} 
  privkey = your private key
  type = :p2pkh | :p2sh
  ## Examples

      iex(4)> AddressGenerator.generate_address(<<74, 194, 89, 189, 160, 160, 203, 1, 54, 191, 82, 87, 194, 12, 30, 173, 35,11, 33, 149, 159, 21, 71, 191, 193, 245, 182, 193, 132, 88, 201, 118>>,:p2pkh)
      {:ok,
       {<<74, 194, 89, 189, 160, 160, 203, 1, 54, 191, 82, 87, 194, 12, 30, 173, 35,11, 33, 149, 159, 21, 71, 191, 193, 245, 182, 193, 132, 88, 201, 118>>,
        "18vWd3uWa43pzfmrL1Err8BtEgUE8eD1sx"}}
  """
  def generate_address(privkey, type) do
    if type == :p2pkh || type == :p2sh do
      {publickey, _} = :crypto.generate_key(:ecdh, :secp256k1)
      generate_address_common(publickey, privkey, type)
    else
      {:error, :invalid_type}
    end
  end

  @doc """
  check if the address is valid,return true | false
  privkey = your private key
  type = :p2pkh | :p2sh
  ## Examples
  
      iex(6)> AddressGenerator.address_valid?("3DGsfL9MKnqDdnqBTpEgm4MASWVZ4Bp2Cv", :p2sh)
      true
  """
  def address_valid?(address, type) do 
      with true <- length_valid?(address),
           true <- (type == :p2pkh && String.first(address) == "1") || (type == :p2sh && String.first(address) == "3"),
           do: decode_check_valid?(address)
  end

  defp length_valid?(address) do
    ad_len = String.length(address)
    if ad_len >= 26 && ad_len <= 35 do
      true
    else
      IO.puts "length should between 26 and 35"
      false
    end
  end

  defp decode_check_valid?(address) do
    address_decode = Base58.decode(address)
    address_decode = add_zero_at_head(address_decode, 25 - byte_size(address_decode))
    <<script_hash::binary-size(21), double_sha::binary>> = address_decode
    <<double_sha_now::binary-size(4),_::binary>> = :crypto.hash(:sha256, :crypto.hash(:sha256, script_hash))
    double_sha == double_sha_now
  end

  defp add_zero_at_head(address_decode, count) when count<=1 do
    if count == 0 do
      address_decode
    else
      <<0x00>> <> address_decode
    end
  end

  defp add_zero_at_head(address_decode, count) do
    add_zero_at_head(<<0x00>> <> address_decode, count - 1)
  end

  defp generate_address_common(publickey, privkey, type) do
    public_hash = double_hash(publickey)
    
    cond do 
      type == :p2pkh ->
        {:ok, {privkey, p2pkh(public_hash)}}
      type == :p2sh ->
        {:ok, {privkey, p2sh(public_hash)}}
    end
  end

  defp double_hash(data) do
    tmp = :crypto.hash(:sha256, data)
    :crypto.hash(:ripemd160, tmp)
  end

  defp p2pkh(public_hash, version \\ <<0x00>>) do
    Base58Check.encode(public_hash,version)
  end

  defp p2sh(public_hash, version \\ <<0x05>>) do
    op_num = <<0x00>>
    bytes_num = <<0x14>>
    script_hash = double_hash(op_num <> bytes_num <> public_hash)
    Base58Check.encode(script_hash, version)
  end

end