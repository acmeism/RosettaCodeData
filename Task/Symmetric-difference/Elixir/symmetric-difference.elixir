iex(1)> a = ~w[John Bob Mary Serena] |> MapSet.new
#MapSet<["Bob", "John", "Mary", "Serena"]>
iex(2)> b = ~w[Jim Mary John Bob] |> MapSet.new
#MapSet<["Bob", "Jim", "John", "Mary"]>
iex(3)> sym_dif = fn(a,b) -> MapSet.difference(MapSet.union(a,b), MapSet.intersection(a,b)) end
#Function<12.54118792/2 in :erl_eval.expr/5>
iex(4)> sym_dif.(a,b)
#MapSet<["Jim", "Serena"]>
