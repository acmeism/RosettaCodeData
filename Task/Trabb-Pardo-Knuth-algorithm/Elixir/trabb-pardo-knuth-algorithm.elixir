defmodule Trabb_Pardo_Knuth do
  def task do
    Enum.reverse( get_11_numbers )
    |> Enum.each( fn x -> perform_operation( &function(&1), 400, x ) end )
  end

  defp alert( n ), do: IO.puts "Operation on #{n} overflowed"

  defp get_11_numbers do
    ns = IO.gets( "Input 11 integers.  Space delimited, please: " )
         |> String.split
         |> Enum.map( &String.to_integer &1 )
    if 11 == length( ns ), do: ns, else: get_11_numbers
  end

  defp function( x ), do: :math.sqrt( abs(x) ) + 5 * :math.pow( x, 3 )

  defp perform_operation( fun, overflow, n ), do: perform_operation_check_overflow( n, fun.(n), overflow )

  defp perform_operation_check_overflow( n, result, overflow ) when result > overflow, do: alert( n )
  defp perform_operation_check_overflow( n, result, _overflow ), do: IO.puts "f(#{n}) => #{result}"
end

Trabb_Pardo_Knuth.task
