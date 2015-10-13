iex(10)> numbers = Enum.to_list(1..9)
[1, 2, 3, 4, 5, 6, 7, 8, 9]
iex(11)> Enum.filter(numbers, fn x -> rem(x,2)==0 end)
[2, 4, 6, 8]
iex(12)> for x <- numbers, rem(x,2)==0, do: x          # comprehension
[2, 4, 6, 8]
