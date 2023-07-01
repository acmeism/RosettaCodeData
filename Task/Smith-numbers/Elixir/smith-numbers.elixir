defmodule Smith do
  def number?(n) do
    d = decomposition(n)
    length(d)>1 and sum_digits(n) == Enum.map(d, &sum_digits/1) |> Enum.sum
  end

  defp sum_digits(n) do
    Integer.digits(n) |> Enum.sum
  end

  defp decomposition(n, k\\2, acc\\[])
  defp decomposition(n, k, acc) when n < k*k, do: [n | acc]
  defp decomposition(n, k, acc) when rem(n, k) == 0, do: decomposition(div(n, k), k, [k | acc])
  defp decomposition(n, k, acc), do: decomposition(n, k+1, acc)
end

m = 10000
smith = Enum.filter(1..m, &Smith.number?/1)
IO.puts "#{length(smith)} smith numbers below #{m}:"
IO.puts "First 10: #{Enum.take(smith,10) |> Enum.join(", ")}"
IO.puts "Last  10: #{Enum.take(smith,-10) |> Enum.join(", ")}"
