iter = Iterators.product(["the", "that", "a"], ["frog", "elephant", "thing"],  ["walked", "treaded", "grows"],  ["slowly", "quickly"])
@show [join(c, " ") for c in iter if all(i -> c[i][end] == c[i + 1][begin], 1:length(c)-1)] # ["that thing grows slowly"]
