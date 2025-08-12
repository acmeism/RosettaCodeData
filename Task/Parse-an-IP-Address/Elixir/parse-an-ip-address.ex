#!/usr/bin/env elixir

defmodule IPParse do
  @moduledoc """
  IP address parser that handles IPv4 and IPv6 addresses with optional ports
  """

  def main(args \\ []) do
    addresses = if Enum.empty?(args), do: data(), else: args

    for addr <- addresses do
      print(addr, parse(addr))
    end

    System.halt(0)
  end

  @spec parse(String.t()) ::
    {String.t(), binary(), String.t()} |
    {String.t(), binary()}
  def parse("[" <> addr0) do
    case String.split(addr0, "]", parts: 2) do
      [addr] ->
        {"IPv6", to_hex(:inet.parse_address(String.to_charlist(addr)))}

      [addr, ":" <> port] ->
        {"IPv6", to_hex(:inet.parse_address(String.to_charlist(addr))), port}
    end
  end

  def parse(addr0) do
    case :inet.parse_address(String.to_charlist(addr0)) do
      {:error, :einval} ->
        [addr, port] = String.split(addr0, ":", parts: 2)
        {"IPv4", to_hex(:inet.parse_address(String.to_charlist(addr))), port}

      {:ok, v6_addr} ->
        {"IPv6", to_hex({:ok, v6_addr})}
    end
  end

  @spec to_hex({:ok, :inet.ip_address()}) :: binary()
  def to_hex({:ok, {a, b, c, d}}) do
    Base.encode16(<<a::8, b::8, c::8, d::8>>)
  end

  def to_hex({:ok, {a, b, c, d, e, f, g, h}}) do
    Base.encode16(<<a::16, b::16, c::16, d::16, e::16, f::16, g::16, h::16>>)
  end

  def print(input, {family, hex, port}) do
    IO.puts("Input: #{input}")
    IO.puts("Family: #{family}")
    IO.puts("Hex: #{hex}")
    IO.puts("Port: #{port}")
    IO.puts("")
  end

  def print(input, {family, hex}) do
    IO.puts("Input: #{input}")
    IO.puts("Family: #{family}")
    IO.puts("Hex: #{hex}")
    IO.puts("")
  end

  defp data do
    [
      "127.0.0.1",
      "127.0.0.1:80",
      "::ffff:127.0.0.1",
      "::1",
      "[::1]:80",
      "1::80",
      "2605:2700:0:3::4713:93e3",
      "[2605:2700:0:3::4713:93e3]:80"
    ]
  end
end

# Run the main function if this script is executed directly
if __ENV__.file == Path.absname(:escript.script_name()) do
  IPParse.main(System.argv())
end
