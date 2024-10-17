defmodule LeftFactorial do
  def calc(0), do: 0
  def calc(n) do
    {result, _factorial} = Enum.reduce(1..n, {0, 1}, fn i,{res, fact} ->
      {res + fact, fact * i}
    end)
    result
  end
end

Enum.each(0..10, fn i ->
  IO.puts "!#{i} = #{LeftFactorial.calc(i)}"
end)
Enum.each(Enum.take_every(20..110, 10), fn i ->
  IO.puts "!#{i} = #{LeftFactorial.calc(i)}"
end)
Enum.each(Enum.take_every(1000..10000, 1000), fn i ->
  digits = LeftFactorial.calc(i) |> to_char_list |> length
  IO.puts "!#{i} has #{digits} digits"
end)
