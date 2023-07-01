defmodule Knapsack do
  def solve([], _total_weight, item_acc, value_acc, weight_acc), do:
    {item_acc, value_acc, weight_acc}
  def solve([{_item, item_weight, _item_value} | t],
            total_weight,
            item_acc,
            value_acc,
            weight_acc) when item_weight > total_weight, do:
    solve(t, total_weight, item_acc, value_acc, weight_acc)
  def solve([{item_name, item_weight, item_value} | t],
            total_weight,
            item_acc,
            value_acc,
            weight_acc) do
    {_tail_item_acc, tail_value_acc, _tail_weight_acc} = tail_res =
        solve(t, total_weight, item_acc, value_acc, weight_acc)
    {_head_item_acc, head_value_acc, _head_weight_acc} = head_res =
        solve(t,
              total_weight - item_weight,
              [item_name | item_acc],
              value_acc + item_value,
              weight_acc + item_weight)
    if tail_value_acc > head_value_acc, do: tail_res, else: head_res
  end
end

stuff = [{"map",                      9,   150},
         {"compass",                 13,    35},
         {"water",                  153,   200},
         {"sandwich",                50,   160},
         {"glucose",                 15,    60},
         {"tin",                     68,    45},
         {"banana",                  27,    60},
         {"apple",                   39,    40},
         {"cheese",                  23,    30},
         {"beer",                    52,    10},
         {"suntan cream",            11,    70},
         {"camera",                  32,    30},
         {"T-shirt",                 24,    15},
         {"trousers",                48,    10},
         {"umbrella",                73,    40},
         {"waterproof trousers",     42,    70},
         {"waterproof overclothes",  43,    75},
         {"note-case",               22,    80},
         {"sunglasses",               7,    20},
         {"towel",                   18,    12},
         {"socks",                    4,    50},
         {"book",                    30,    10}]
max_weight = 400

go = fn (stuff, max_weight) ->
  {time, {item_list, total_value, total_weight}} = :timer.tc(fn ->
    Knapsack.solve(stuff, max_weight, [], 0, 0)
  end)
  IO.puts "Items:"
  Enum.each(item_list, fn item -> IO.inspect item end)
  IO.puts "Total value: #{total_value}"
  IO.puts "Total weight: #{total_weight}"
  IO.puts "Time elapsed in milliseconds: #{time/1000}"
end
go.(stuff, max_weight)
