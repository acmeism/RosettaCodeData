iex(1)> keys = [:one, :two, :three]
[:one, :two, :three]
iex(2)> values = [1, 2, 3]
[1, 2, 3]
iex(3)> Enum.zip(keys, values) |> Enum.into(Map.new)
%{one: 1, three: 3, two: 2}
