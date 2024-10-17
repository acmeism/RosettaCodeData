iex(26)> Enum.reduce([1,2,3,4,5], 0, fn x,acc -> x+acc end)
15
iex(27)> Enum.reduce([1,2,3,4,5], 1, fn x,acc -> x*acc end)
120
iex(28)> Enum.reduce([1,2,3,4,5], fn x,acc -> x+acc end)
15
iex(29)> Enum.reduce([1,2,3,4,5], fn x,acc -> x*acc end)
120
iex(30)> Enum.reduce([], 0, fn x,acc -> x+acc end)
0
iex(31)> Enum.reduce([], 1, fn x,acc -> x*acc end)
1
iex(32)> Enum.reduce([], fn x,acc -> x+acc end)
** (Enum.EmptyError) empty error
    (elixir) lib/enum.ex:1287: Enum.reduce/2
iex(32)> Enum.reduce([], fn x,acc -> x*acc end)
** (Enum.EmptyError) empty error
    (elixir) lib/enum.ex:1287: Enum.reduce/2
