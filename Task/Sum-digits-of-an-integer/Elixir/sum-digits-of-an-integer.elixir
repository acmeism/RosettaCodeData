defmodule RC do
  def sumDigits(n, base\\10)
  def sumDigits(n, base) when is_integer(n) do
    Integer.digits(n, base) |> Enum.sum
  end
  def sumDigits(n, base) when is_binary(n) do
    String.codepoints(n) |> Enum.map(&String.to_integer(&1, base)) |> Enum.sum
  end
end

Enum.each([{1, 10}, {1234, 10}, {0xfe, 16}, {0xf0e, 16}], fn {n,base} ->
  IO.puts "#{Integer.to_string(n,base)}(#{base}) sums to #{ RC.sumDigits(n,base) }"
end)
IO.puts ""
Enum.each([{"1", 10}, {"1234", 10}, {"fe", 16}, {"f0e", 16}], fn {n,base} ->
  IO.puts "#{n}(#{base}) sums to #{ RC.sumDigits(n,base) }"
end)
