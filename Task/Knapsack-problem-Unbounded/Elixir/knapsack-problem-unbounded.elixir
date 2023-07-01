defmodule Item do
  defstruct volume: 0.0, weight: 0.0, value: 0
  def new(volume, weight, value) do
    %__MODULE__{volume: volume, weight: weight, value: value}
  end
end

defmodule Knapsack do
  def solve_unbounded(items, maximum) do
    {max_volume, max_weight} = {maximum.volume, maximum.weight}
    max_items = Enum.map(items, fn {name,item} ->
      {name, trunc(min(max_volume / item.volume, max_weight / item.weight))}
    end)
    Enum.map(max_items, fn {name,max} -> for i <- 0..max, do: {name,i} end)
    |> product
    |> total(items)
    |> Enum.filter(fn {_kw, {volume,weight,_}} -> volume <= max_volume and
                                                  weight <= max_weight end)
    |> Enum.group_by(fn {_kw, {_,_,value}} -> value end)
    |> Enum.max
    |> print
  end

  defp product([x]), do: x
  defp product([a,b]), do: for x <- a, y <- b, do: [x,y]
  defp product([h|t]), do: for x <- h, y <- product(t), do: [x | y]

  defp total(lists, items) do
    Enum.map(lists, fn kwlist ->
      total = Enum.reduce(kwlist, {0,0,0}, fn {name,n},{volume,weight,value} ->
        {volume + n * items[name].volume,
         weight + n * items[name].weight,
         value  + n * items[name].value}
      end)
      {kwlist, total}
    end)
  end

  defp print({max_value, data}) do
    IO.puts "Maximum value achievable is #{max_value}\tvolume  weight  value"
    Enum.each(data, fn {kw,{volume,weight,value}} ->
      :io.format "~s =>\t~6.3f, ~5.1f, ~6w~n", [(inspect kw), volume, weight, value]
    end)
  end
end

items = %{panacea: Item.new(0.025, 0.3, 3000),
          ichor:   Item.new(0.015, 0.2, 1800),
          gold:    Item.new(0.002, 2.0, 2500) }
maximum = Item.new(0.25, 25, 0)
Knapsack.solve_unbounded(items, maximum)
