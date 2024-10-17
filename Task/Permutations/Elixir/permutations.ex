defmodule RC do
  def permute([]), do: [[]]
  def permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x|y]
  end
end

IO.inspect RC.permute([1, 2, 3])
