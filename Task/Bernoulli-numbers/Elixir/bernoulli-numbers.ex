defmodule Bernoulli do
  defmodule Rational do
    import Kernel, except: [div: 2]

    defstruct numerator: 0, denominator: 1

    def new(numerator, denominator\\1) do
      sign = if numerator * denominator < 0, do: -1, else: 1
      {numerator, denominator} = {abs(numerator), abs(denominator)}
      gcd = gcd(numerator, denominator)
      %Rational{numerator: sign * Kernel.div(numerator, gcd),
                denominator: Kernel.div(denominator, gcd)}
    end

    def sub(a, b) do
      new(a.numerator * b.denominator - b.numerator * a.denominator,
          a.denominator * b.denominator)
    end

    def mul(a, b) when is_integer(a) do
      new(a * b.numerator, b.denominator)
    end

    defp gcd(a,0), do: a
    defp gcd(a,b), do: gcd(b, rem(a,b))
  end

  def numbers(n) do
    Stream.transform(0..n, {}, fn m,acc ->
      acc = Tuple.append(acc, Rational.new(1,m+1))
      if m>0 do
        new =
          Enum.reduce(m..1, acc, fn j,ar ->
            put_elem(ar, j-1, Rational.mul(j, Rational.sub(elem(ar,j-1), elem(ar,j))))
          end)
        {[elem(new,0)], new}
      else
        {[elem(acc,0)], acc}
      end
    end) |> Enum.to_list
  end

  def task(n \\ 61) do
    b_nums = numbers(n)
    width  = Enum.map(b_nums, fn b -> b.numerator |> to_string |> String.length end)
             |> Enum.max
    format = 'B(~2w) = ~#{width}w / ~w~n'
    Enum.with_index(b_nums)
    |> Enum.each(fn {b,i} ->
         if b.numerator != 0, do: :io.fwrite format, [i, b.numerator, b.denominator]
       end)
  end
end

Bernoulli.task
