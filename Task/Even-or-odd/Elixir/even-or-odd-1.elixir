defmodule RC do
  import Integer

  def even_or_odd(n) when is_even(n), do: "#{n} is even"
  def even_or_odd(n)                , do: "#{n} is odd"
      # In second "def", the guard clauses of "is_odd(n)" is unnecessary.

  # Another definition way
  def even_or_odd2(n) do
    if is_even(n), do: "#{n} is even", else: "#{n} is odd"
  end
end

Enum.each(-2..3, fn n -> IO.puts RC.even_or_odd(n) end)
