defmodule KnapsackProblem do
  def continuous(items, max_weight) do
    Enum.sort_by(items, fn {_item, {weight, price}} -> -price / weight end)
    |> Enum.reduce_while({max_weight,0}, fn {item, {weight, price}}, {rest, value} ->
         if rest > weight do
           IO.puts "Take all #{item}"
           {:cont, {rest - weight, value + price}}
         else
           :io.format "Take ~.3fkg of ~s~n~n", [rest, item]
           :io.format "Total value of swag is ~.2f~n", [value + rest*price/weight]
           {:halt, :ok}
         end
       end)
    |> case do
         {weight, value} ->
             :io.format "Total:  weight ~.3fkg, value ~p~n", [max_weight-weight, value]
         x -> x
       end
  end
end

items = [ beef:    {3.8, 36},
          pork:    {5.4, 43},
          ham:     {3.6, 90},
          greaves: {2.4, 45},
          flitch:  {4.0, 30},
          brawn:   {2.5, 56},
          welt:    {3.7, 67},
          salami:  {3.0, 95},
          sausage: {5.9, 98} ]

KnapsackProblem.continuous( items, 15 )
