iex(1)> ls = fn dir -> File.ls!(dir) |> Enum.each(&IO.puts &1) end
#Function<6.54118792/1 in :erl_eval.expr/5>
iex(2)> ls.("foo")
bar
:ok
iex(3)> ls.("foo/bar")
1
2
a
b
:ok
