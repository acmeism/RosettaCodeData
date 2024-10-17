defmodule RC do
  def flatten([]), do: []
  def flatten([h|t]), do: flatten(h) ++ flatten(t)
  def flatten(h), do: [h]
end

list = [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]

# Our own implementation
IO.inspect RC.flatten(list)
# Library function
IO.inspect List.flatten(list)
