l1 = ["a", "b", "c"]
l2 = ["A", "B", "C"]
l3 = ["1", "2", "3"]
IO.inspect List.zip([l1,l2,l3]) |> Enum.map(fn x-> Tuple.to_list(x) |> Enum.join end)
#=> ["aA1", "bB2", "cC3"]
