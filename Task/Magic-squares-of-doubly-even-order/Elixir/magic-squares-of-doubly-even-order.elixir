defmodule Magic_square do
  def doubly_even(n) when rem(n,4)!=0, do: raise ArgumentError, "must be even, but not divisible by 4."
  def doubly_even(n) do
    n2 = n * n
    Enum.zip(1..n2, make_pattern(n))
    |> Enum.map(fn {i,p} -> if p, do: i, else: n2 - i + 1 end)
    |> Enum.chunk(n)
    |> to_string(n)
    |> IO.puts
  end

  defp make_pattern(n) do
    pattern = Enum.reduce(1..4, [true], fn _,acc ->
                acc ++ Enum.map(acc, &(!&1))
              end) |> Enum.chunk(4)
    for i <- 0..n-1, j <- 0..n-1, do: Enum.at(pattern, rem(i,4)) |> Enum.at(rem(j,4))
  end

  defp to_string(square, n) do
    format = String.duplicate("~#{length(to_char_list(n*n))}w ", n) <> "\n"
    Enum.map_join(square, fn row ->
      :io_lib.format(format, row)
    end)
  end
end

Magic_square.doubly_even(8)
