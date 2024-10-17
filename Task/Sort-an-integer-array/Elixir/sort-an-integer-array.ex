list = [2, 4, 3, 1, 2]
IO.inspect Enum.sort(list)
IO.inspect Enum.sort(list, &(&1>&2))
