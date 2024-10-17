m = [[1,  1,  1,   1],
     [2,  4,  8,  16],
     [3,  9, 27,  81],
     [4, 16, 64, 256],
     [5, 25,125, 625]]

transpose = fn(m)-> List.zip(m) |> Enum.map(&Tuple.to_list(&1)) end

IO.inspect transpose.(m)
