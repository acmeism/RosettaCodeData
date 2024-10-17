defmodule RC do
  def root_mean_square(enum) do
    enum
    |> square
    |> mean
    |> :math.sqrt
  end

  defp mean(enum), do: Enum.sum(enum) / Enum.count(enum)

  defp square(enum), do: (for x <- enum, do: x * x)
end

IO.puts RC.root_mean_square(1..10)
