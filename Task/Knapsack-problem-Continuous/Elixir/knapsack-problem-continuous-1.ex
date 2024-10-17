defmodule KnapsackProblem do
  def select( max_weight, items ) do
    Enum.sort_by( items, fn {_name, weight, price} -> - price / weight end )
    |> Enum.reduce( {max_weight, []}, &select_until/2 )
    |> elem(1)
    |> Enum.reverse
  end

  def task( items, max_weight ) do
    IO.puts "The robber takes the following to maximize the value"
    Enum.each( select( max_weight, items ), fn {name, weight} ->
      :io.fwrite("~.2f of ~s~n", [weight, name])
    end )
  end

  defp select_until( {name, weight, _price}, {remains, acc} ) when remains > 0 do
    selected_weight = select_until_weight( weight, remains )
    {remains - selected_weight, [{name, selected_weight} | acc]}
  end
  defp select_until( _item, acc ), do: acc

  defp select_until_weight( weight, remains ) when weight < remains, do: weight
  defp select_until_weight( _weight, remains ), do: remains
end

items = [ {"beef",    3.8, 36},
          {"pork",    5.4, 43},
          {"ham",     3.6, 90},
          {"greaves", 2.4, 45},
          {"flitch",  4.0, 30},
          {"brawn",   2.5, 56},
          {"welt",    3.7, 67},
          {"salami",  3.0, 95},
          {"sausage", 5.9, 98} ]

KnapsackProblem.task( items, 15 )
