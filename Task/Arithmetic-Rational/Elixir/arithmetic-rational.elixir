defmodule Rational do
  import Kernel, except: [div: 2]

  defstruct numerator: 0, denominator: 1

  def new(numerator), do: %Rational{numerator: numerator, denominator: 1}

  def new(numerator, denominator) do
    sign = if numerator * denominator < 0, do: -1, else: 1
    {numerator, denominator} = {abs(numerator), abs(denominator)}
    gcd = gcd(numerator, denominator)
    %Rational{numerator: sign * Kernel.div(numerator, gcd),
              denominator: Kernel.div(denominator, gcd)}
  end

  def add(a, b) do
    {a, b} = convert(a, b)
    new(a.numerator * b.denominator + b.numerator * a.denominator,
        a.denominator * b.denominator)
  end

  def sub(a, b) do
    {a, b} = convert(a, b)
    new(a.numerator * b.denominator - b.numerator * a.denominator,
        a.denominator * b.denominator)
  end

  def mult(a, b) do
    {a, b} = convert(a, b)
    new(a.numerator * b.numerator, a.denominator * b.denominator)
  end

  def div(a, b) do
    {a, b} = convert(a, b)
    new(a.numerator * b.denominator, a.denominator * b.numerator)
  end

  defp convert(a), do: if is_integer(a), do: new(a), else: a

  defp convert(a, b), do: {convert(a), convert(b)}

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))
end

defimpl Inspect, for: Rational do
  def inspect(r, _opts) do
    "%Rational<#{r.numerator}/#{r.denominator}>"
  end
end

Enum.each(2..trunc(:math.pow(2,19)), fn candidate ->
  sum = 2 .. round(:math.sqrt(candidate))
        |> Enum.reduce(Rational.new(1, candidate), fn factor,sum ->
             if rem(candidate, factor) == 0 do
               Rational.add(sum, Rational.new(1, factor))
               |> Rational.add(Rational.new(1, div(candidate, factor)))
             else
               sum
             end
           end)
  if sum.denominator == 1 do
    :io.format "Sum of recipr. factors of ~6w = ~w exactly ~s~n",
           [candidate, sum.numerator, (if sum.numerator == 1, do: "perfect!", else: "")]
  end
end)
