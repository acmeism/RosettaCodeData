empty_map = Map.new           #=> %{}
kwlist = [x: 1, y: 2]         #   Key Word List
Map.new(kwlist)               #=> %{x: 1, y: 2}
Map.new([{1,"A"}, {2,"B"}])   #=> %{1 => "A", 2 => "B"}
map = %{:a => 1, 2 => :b}     #=> %{2 => :b, :a => 1}
map[:a]                       #=> 1
map[2]                        #=> :b

# If you pass duplicate keys when creating a map, the last one wins:
%{1 => 1, 1 => 2}             #=> %{1 => 2}

# When all the keys in a map are atoms, you can use the keyword syntax for convenience:
map = %{:a => 1, :b => 2}     #=> %{a: 1, b: 2}
map.a                         #=> 1
%{map | :a => 2}              #=> %{a: 2, b: 2}     update only
