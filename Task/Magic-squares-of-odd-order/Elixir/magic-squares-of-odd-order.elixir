defmodule RC do
  def odd_magic_square(n) when rem(n,2)==1 do
    for i <- 0..n-1 do
      for j <- 0..n-1, do: n * rem(i+j+1+div(n,2),n) + rem(i+2*j+2*n-5,n) + 1
    end
  end

  def print_square(sq) do
    width = List.flatten(sq) |> Enum.max |> to_char_list |> length
    fmt = String.duplicate(" ~#{width}w", length(sq)) <> "~n"
    Enum.each(sq, fn row -> :io.format fmt, row end)
  end
end

Enum.each([3,5,11], fn n ->
  IO.puts "\nSize #{n}, magic sum #{div(n*n+1,2)*n}"
  RC.odd_magic_square(n) |> RC.print_square
end)
