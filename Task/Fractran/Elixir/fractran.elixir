defmodule Fractran do
  use Bitwise

  defp binary_to_ratio(b) do
    [_, num, den] = Regex.run(~r/(\d+)\/(\d+)/, b)
    {String.to_integer(num), String.to_integer(den)}
  end

  def load(program) do
    String.split(program) |> Enum.map(&binary_to_ratio(&1))
  end

  defp step(_, []), do: :halt
  defp step(n, [f|fs]) do
    {p, q} = mulrat(f, {n, 1})
    case q do
        1 -> p
        _ -> step(n, fs)
    end
  end

  def exec(k, n, program) do
    exec(k-1, n, fn (_) -> true end, program, [n]) |> Enum.reverse
  end

  def exec(k, n, pred, program) do
    exec(k-1, n, pred, program, [n]) |> Enum.reverse
  end

  defp exec(0, _, _, _, steps), do: steps
  defp exec(k, n, pred, program, steps) do
    case step(n, program) do
        :halt -> steps
        m -> if pred.(m), do: exec(k-1, m, pred, program, [m|steps]),
                        else: exec(k, m, pred, program, steps)
    end
  end

  def is_pow2(n), do: band(n, n-1) == 0

  def lowbit(n), do: lowbit(n, 0)

  defp lowbit(n, k) do
    case band(n, 1) do
        0 -> lowbit(bsr(n, 1), k + 1)
        1 -> k
    end
  end

  # rational multiplication
  defp mulrat({a, b}, {c, d}) do
    {p, q} = {a*c, b*d}
    g = gcd(p, q)
    {div(p, g), div(q, g)}
  end

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))
end

primegen = Fractran.load("17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1")
IO.puts "The first few states of the Fractran prime automaton are:\n#{inspect Fractran.exec(20, 2, primegen)}\n"
prime = Fractran.exec(26, 2, &Fractran.is_pow2/1, primegen)
        |> Enum.map(&Fractran.lowbit/1)
        |> tl
IO.puts "The first few primes are:\n#{inspect prime}"
