println("Real states:")
foreach(println, StateNamePuzzle.solve(StateNamePuzzle.realnames))

println("\nReal + fictitious state:")
foreach(println, StateNamePuzzle.solve(vcat(StateNamePuzzle.realnames,
    StateNamePuzzle.fictitious)))
