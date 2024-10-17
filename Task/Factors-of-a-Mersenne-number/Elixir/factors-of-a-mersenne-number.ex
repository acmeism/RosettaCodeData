defmodule Mersenne do
  def mersenne_factor(p) do
    limit = :math.sqrt(:math.pow(2, p) - 1)
    mersenne_loop(p, limit, 1)
  end

  defp mersenne_loop(p, limit, k) when (2*k*p - 1) > limit, do: nil
  defp mersenne_loop(p, limit, k) do
    q = 2*k*p + 1
    if prime?(q) and rem(q,8) in [1,7] and trial_factor(2,p,q),
      do: q, else: mersenne_loop(p, limit, k+1)
  end

  defp trial_factor(base, exp, mod) do
    Integer.digits(exp, 2)
    |> Enum.reduce(1, fn bit,square ->
      (square * square * (if bit==1, do: base, else: 1)) |> rem(mod)
    end) == 1
  end

  def check_mersenne(p) do
    IO.write "M#{p} = 2**#{p}-1 is "
    f = mersenne_factor(p)
    IO.puts if f, do: "composite with factor #{f}", else: "prime"
  end

  def prime?(n), do: prime?(n, :math.sqrt(n), 2)

  defp prime?(_, limit, i) when limit < i, do: true
  defp prime?(n, limit, i) do
    if rem(n,i) == 0, do: false, else: prime?(n, limit, i+1)
  end
end

[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,929]
|> Enum.each(fn p -> Mersenne.check_mersenne(p) end)
