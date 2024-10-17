defmodule RC do
  def sparkline(str) do
    values = str |> String.split(~r/(,| )+/)
                 |> Enum.map(&elem(Float.parse(&1), 0))
    {min, max} = Enum.min_max(values)
    IO.puts Enum.map(values, &(round((&1 - min) / (max - min) * 7 + 0x2581)))
  end
end
