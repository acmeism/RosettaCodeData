defmodule RC do
  def set_consolidate(sets, result\\[])
  def set_consolidate([], result), do: result
  def set_consolidate([h|t], result) do
    case Enum.find(t, fn set -> not MapSet.disjoint?(h, set) end) do
      nil -> set_consolidate(t, [h | result])
      set -> set_consolidate([MapSet.union(h, set) | t -- [set]], result)
    end
  end
end

examples = [[[:A,:B], [:C,:D]],
            [[:A,:B], [:B,:D]],
            [[:A,:B], [:C,:D], [:D,:B]],
            [[:H,:I,:K], [:A,:B], [:C,:D], [:D,:B], [:F,:G,:H]]]
           |> Enum.map(fn sets ->
                Enum.map(sets, fn set -> MapSet.new(set) end)
              end)

Enum.each(examples, fn sets ->
  IO.write "#{inspect sets} =>\n\t"
  IO.inspect RC.set_consolidate(sets)
end)
