defmodule Palindromic do
  import Integer, only: [is_odd: 1]

  def number23 do
    Stream.concat([0,1], Stream.unfold(1, &number23/1))
  end
  def number23(i) do
    n3 = Integer.to_string(i,3)
    n = (n3 <> "1" <> String.reverse(n3)) |> String.to_integer(3)
    n2 = Integer.to_string(n,2)
    if is_odd(String.length(n2)) and n2 == String.reverse(n2),
      do:   {n, i+1},
      else: number23(i+1)
  end

  def task do
    IO.puts "     decimal          ternary                          binary"
    number23()
    |> Enum.take(6)
    |> Enum.each(fn n ->
      n3 = Integer.to_charlist(n,3) |> :string.centre(25)
      n2 = Integer.to_charlist(n,2) |> :string.centre(39)
      :io.format "~12w ~s ~s~n", [n, n3, n2]
    end)
  end
end

Palindromic.task
