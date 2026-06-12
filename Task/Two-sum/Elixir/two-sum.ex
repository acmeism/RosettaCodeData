defmodule RC do
  def two_sum(numbers, sum) do
    Enum.with_index(numbers) |>
    Enum.reduce_while([], fn {x,i},acc ->
      y = sum - x
      case Enum.find_index(numbers, &(&1 == y)) do
        nil -> {:cont, acc}
        j   -> {:halt, [i,j]}
      end
    end)
  end
end

numbers = [0, 2, 11, 19, 90]
IO.inspect RC.two_sum(numbers, 21)
IO.inspect RC.two_sum(numbers, 25)
