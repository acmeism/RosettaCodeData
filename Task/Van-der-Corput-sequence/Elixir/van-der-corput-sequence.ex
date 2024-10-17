defmodule Van_der_corput do
  def sequence( n, base \\ 2 ) do
    "0." <> (Integer.to_string(n, base) |> String.reverse )
  end

  def float( n, base \\ 2 ) do
    Integer.digits(n, base) |> Enum.reduce(0, fn i,acc -> (i + acc) / base end)
  end

  def fraction( n, base \\ 2 ) do
    str = Integer.to_string(n, base) |> String.reverse
    denominator = Enum.reduce(1..String.length(str), 1, fn _,acc -> acc*base end)
    reduction( String.to_integer(str, base), denominator )
  end

  defp reduction( 0, _ ), do: "0"
  defp reduction( numerator, denominator ) do
    gcd = gcd( numerator, denominator )
    "#{ div(numerator, gcd) }/#{ div(denominator, gcd) }"
  end

  defp gcd( a, 0 ), do: a
  defp gcd( a, b ), do: gcd( b, rem(a, b) )
end

funs = [ {"Float(Base):",     &Van_der_corput.sequence/2},
         {"Float(Decimal):",  &Van_der_corput.float/2   },
         {"Fraction:",        &Van_der_corput.fraction/2} ]
Enum.each(funs, fn {title, fun} ->
  IO.puts title
  Enum.each(2..5, fn base ->
    IO.puts "  Base #{ base }: #{ Enum.map_join(0..9, ", ", &fun.(&1, base)) }"
  end)
end)
