l1 = 'abc'
l2 = 'ABC'
l3 = '123'
IO.inspect List.zip([l1,l2,l3]) |> Enum.map(fn x-> Tuple.to_list(x) end)
#=> ['aA1', 'bB2', 'cC3']
