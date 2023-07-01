? def prog := <elang:syntax.makeEParser>.run("1 + 1")
# value: e`1.add(1)`

? prog.eval(safeScope)
# value: 2
