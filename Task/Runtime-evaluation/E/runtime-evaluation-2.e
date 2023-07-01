? def [value, env] := e`def x := 1 + 1`.evalToPair(safeScope)
# value: [2, ...]

? e`x`.eval(env)
# value: 2
