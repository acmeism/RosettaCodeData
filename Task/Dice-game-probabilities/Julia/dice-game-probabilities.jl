play(ndices::Integer, nfaces::Integer) = (nfaces, ndices) ∋ 0 ? 0 : sum(rand(1:nfaces) for i in 1:ndices)

simulate(d1::Integer, f1::Integer, d2::Integer, f2::Integer; nrep::Integer=1_000_000) =
    mean(play(d1, f1) > play(d2, f2) for _ in 1:nrep)

println("\nPlayer 1: 9 dices, 4 faces\nPlayer 2: 6 dices, 6 faces\nP(Player1 wins) = ", simulate(9, 4, 6, 6))
println("\nPlayer 1: 5 dices, 10 faces\nPlayer 2: 6 dices, 7 faces\nP(Player1 wins) = ", simulate(5, 10, 6, 7))
