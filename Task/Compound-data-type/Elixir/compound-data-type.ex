iex(1)> defmodule Point do
...(1)>   defstruct x: 0, y: 0
...(1)> end
{:module, Point, <<70, 79, 82, ...>>, %Point{x: 0, y: 0}}
iex(2)> origin = %Point{}
%Point{x: 0, y: 0}
iex(3)> pa = %Point{x: 10, y: 20}
%Point{x: 10, y: 20}
iex(4)> pa.x
10
iex(5)> %Point{pa | y: 30}
%Point{x: 10, y: 30}
iex(6)> %Point{x: px, y: py} = pa        # pattern matching
%Point{x: 10, y: 20}
iex(7)> px
10
iex(8)> py
20
