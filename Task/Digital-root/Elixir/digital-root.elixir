defmodule Digital do
  def root(n, base\\10), do: root(n, base, 0)

  defp root(n, base, ap) when n < base, do: {n, ap}
  defp root(n, base, ap) do
    Integer.digits(n, base) |> Enum.sum |> root(base, ap+1)
  end
end

data = [627615, 39390, 588225, 393900588225]
Enum.each(data, fn n ->
  {dr, ap} = Digital.root(n)
  IO.puts "#{n} has additive persistence #{ap} and digital root of #{dr}"
end)

base = 16
IO.puts "\nBase = #{base}"
fmt = "~.#{base}B(#{base}) has additive persistence ~w and digital root of ~w~n"
Enum.each(data, fn n ->
  {dr, ap} = Digital.root(n, base)
  :io.format fmt, [n, ap, dr]
end)
