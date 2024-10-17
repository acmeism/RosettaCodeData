#! /usr/bin/env elixir
defmodule Mentions do
  def get(url) do
    {:ok, {{_, 200, _}, _, body}} =
      url
      |> String.to_charlist()
      |> :httpc.request()
    data = List.to_string(body)
    if Regex.match?(~r|<!Doctype HTML.*<Title>URL Not Found</Title>|s, data) do
      {:error, "log file not found"}
    else
      {:ok, data}
    end
  end

  def perg(haystack, needle) do
    haystack
    |> String.split("\n")
    |> Enum.filter(fn x -> String.contains?(x, needle) end)
  end

  def generate_url(n) do
    date_str =
      DateTime.utc_now()
      |> DateTime.to_unix()
      |> (fn x -> x + 60*60*24*n end).()
      |> DateTime.from_unix!()
      |> (fn %{year: y, month: m, day: d} ->
        :io_lib.format("~B-~2..0B-~2..0B", [y, m, d])
      end).()
    "http://tclers.tk/conferences/tcl/#{date_str}.tcl"
  end
end

[needle] = System.argv()
:application.start(:inets)
back = 10
# Elixir does not come standard with time zone definitions, so we add an extra
# day to account for the possible difference between the local and the server
# time.
for i <- -back..1 do
  url = Mentions.generate_url(i)
  with {:ok, haystack} <- Mentions.get(url),
       # If the result is a non-empty list...
       [h | t] <-  Mentions.perg(haystack, needle) do
    IO.puts("#{url}\n------\n#{Enum.join([h | t], "\n")}\n------\n")
  end
end
