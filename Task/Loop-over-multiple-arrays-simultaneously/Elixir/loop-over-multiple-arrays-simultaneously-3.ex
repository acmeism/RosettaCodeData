iex(1)> List.zip(['abc','ABCD','12345']) |> Enum.map(&Tuple.to_list(&1))
['aA1', 'bB2', 'cC3']
iex(2)> List.zip(['abcde','ABC','12']) |> Enum.map(&Tuple.to_list(&1))
['aA1', 'bB2']
