array_go() -> go(array:new([101, fixed, {default, closed}]), 1, 1).

go(Array, Big, Inc) when Big > 100, Inc =< 100 ->
    go(Array, Inc + 1, Inc + 1);
go(Array, Index, Inc) when Inc < 101 ->
    go(array:set(Index, toggle(Array, Index), Array), Index + Inc, Inc);
go(Array, _, _) -> array:sparse_to_orddict(Array).

toggle(Array, Index) -> toggle(array:get(Index, Array)).
