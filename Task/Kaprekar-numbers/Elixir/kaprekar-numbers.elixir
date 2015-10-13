defmodule KaprekarNumber do
  def check(n), do: check(n, 10)

  def check(1,_base), do: {"1", ""}
  def check(n, base) when rem(n*(n-1), (base-1)) != 0, do: false      # casting out nine
  def check(n, base) do
    square = Integer.to_string(n*n, base)
    check(n, base, square, 1, String.length(square)-1)
  end

  defp check(_, _, _, _, 0), do: false
  defp check(n, base, square, i, remainder) do
    {a, b} = String.split_at(square, i)
    if String.to_integer(b, base) == 0 do
      false
    else
      sum = String.to_integer(a, base) + String.to_integer(b, base)
      if n == sum, do: {a, b}, else: check(n, base, square, i+1, remainder-1)
    end
  end
end

Enum.each(1..9_999, fn n ->
  if result = KaprekarNumber.check(n) do
    {a, b} = result
    :io.fwrite "~6w  ~8s  ~s + ~s~n", [n, a<>b, a, b]
  end
end)

# Extra credit
count = Enum.reduce(1..999_999, 0, fn n,acc ->
  if KaprekarNumber.check(n), do: acc + 1, else: acc
end)
IO.puts "\n#{count} kaprekar numbers under 1,000,000"

# Extra extra credit
base = 17
IO.puts "\nbase #{base} kaprekar numbers under 1,000,000(base10)"
Enum.each(1..999_999, fn n ->
  if result = KaprekarNumber.check(n, base) do
    {a, b} = result
    :io.fwrite "~7w  ~5s  ~9s  ~s + ~s~n", [n, Integer.to_string(n,base), a<>b, a, b]
  end
end)
