defmodule RC do
  def perm_rep(list), do: perm_rep(list, length(list))

  def perm_rep([], _), do: [[]]
  def perm_rep(_,  0), do: [[]]
  def perm_rep(list, i) do
    for x <- list, y <- perm_rep(list, i-1), do: [x|y]
  end
end

list = [1, 2, 3]
Enum.each(1..3, fn n ->
  IO.inspect RC.perm_rep(list,n)
end)
