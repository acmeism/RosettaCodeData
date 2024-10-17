defmodule Heronian do
  def triangle?(a,b,c) when a+b <= c, do: false
  def triangle?(a,b,c) do
    area = area(a,b,c)
    area == round(area) and primitive?(a,b,c)
  end

  def area(a,b,c) do
    s = (a + b + c) / 2
    :math.sqrt(s * (s-a) * (s-b) * (s-c))
  end

  defp primitive?(a,b,c), do: gcd(gcd(a,b),c) == 1

  defp gcd(a,0), do: a
  defp gcd(a,b), do: gcd(b, rem(a,b))
end

max = 200
triangles = for a <- 1..max, b <- a..max, c <- b..max, Heronian.triangle?(a,b,c), do: {a,b,c}
IO.puts length(triangles)

IO.puts "\nSides\t\t\tPerim\tArea"
Enum.map(triangles, fn {a,b,c} -> {Heronian.area(a,b,c),a,b,c} end)
|> Enum.sort
|> Enum.take(10)
|> Enum.each(fn {area, a, b, c} ->
     IO.puts "#{a}\t#{b}\t#{c}\t#{a+b+c}\t#{round(area)}"
   end)
IO.puts ""
area_size = 210
Enum.filter(triangles, fn {a,b,c} -> Heronian.area(a,b,c) == area_size end)
|> Enum.sort_by(fn {a,b,c} -> a+b+c end)
|> Enum.each(fn {a, b, c} ->
     IO.puts "#{a}\t#{b}\t#{c}\t#{a+b+c}\t#{area_size}"
   end)
