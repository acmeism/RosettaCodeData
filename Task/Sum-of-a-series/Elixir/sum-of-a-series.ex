iex(1)> Enum.reduce(1..1000, 0, fn x,sum -> sum + 1/(x*x) end)
1.6439345666815615
