iex(1)> defmodule RC do
...(1)>   def first(f), do: f.()
...(1)>   def second, do: :hello
...(1)> end
{:module, RC,
 <<70, 79, 82, 49, 0, 0, 4, 224, 66, 69, 65, 77, 69, 120, 68, 99, 0, 0, 0, 142,
131, 104, 2, 100, 0, 14, 101, 108, 105, 120, 105, 114, 95, 100, 111, 99, 115, 95
, 118, 49, 108, 0, 0, 0, 2, 104, 2, ...>>,
 {:second, 0}}
iex(2)> RC.first(fn -> RC.second end)
:hello
iex(3)> RC.first(&RC.second/0)			# Another expression
:hello
iex(4)> f = fn -> :world end                    # Anonymous function
#Function<20.54118792/0 in :erl_eval.expr/5>
iex(5)> RC.first(f)
:world
