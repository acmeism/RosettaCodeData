iex(1)> Enum.reduce([3,1,4,1,5,9], 0, fn x,sum -> sum + x*x end)
133
