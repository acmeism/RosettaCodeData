defmodule JensenDevice do
  def task, do: sum( 1, 100, fn i -> 1 / i end )

  defp sum( i, high, _term ) when i > high, do: 0
  defp sum( i, high, term ) do
    temp = term.( i )
    temp + sum( i + 1, high, term )
  end
end

IO.puts JensenDevice.task
