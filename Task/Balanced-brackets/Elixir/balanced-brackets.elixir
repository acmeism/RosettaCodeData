defmodule Balanced_brackets do
  def task do
    Enum.each(0..5, fn n ->
      brackets = generate(n)
      result = is_balanced(brackets) |> task_balanced
      IO.puts "#{brackets} is #{result}"
    end)
  end

  defp generate( 0 ), do: []
  defp generate( n ) do
    for _ <- 1..2*n, do: Enum.random ["[", "]"]
  end

  def is_balanced( brackets ), do: is_balanced_loop( brackets, 0 )

  defp is_balanced_loop( _, n ) when n < 0, do: false
  defp is_balanced_loop( [], 0 ), do: true
  defp is_balanced_loop( [], _n ), do: false
  defp is_balanced_loop( ["[" | t], n ), do: is_balanced_loop( t, n + 1 )
  defp is_balanced_loop( ["]" | t], n ), do: is_balanced_loop( t, n - 1 )

  defp task_balanced( true ), do: "OK"
  defp task_balanced( false ), do: "NOT OK"
end

Balanced_brackets.task
