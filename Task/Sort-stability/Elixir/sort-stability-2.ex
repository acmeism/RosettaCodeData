IO.inspect Enum.sort(cities, fn a,b -> elem(a,0) > elem(b,0) end)
