function countstrange(places, fixedstart=1)
    possibles = [
        [2, 3, 5, 7],
        [3, 4, 6, 8],
        [0, 4, 5, 7, 9],
        [0, 1, 5, 6, 8],
        [1, 2, 6, 7, 9],
        [0, 2, 3, 7, 8],
        [1, 3, 4, 8, 9],
        [0, 2, 4, 5, 9],
        [1, 3, 5, 6],
        [2, 4, 6, 7],
    ]
    strangeones = [fixedstart]
    for _ in 2:places
        newones = Int[]
        for n in strangeones, nextn in possibles[n % 10 + 1]
            push!(newones, n * 10 + nextn)
        end
        strangeones = newones
    end
    println("Found ", length(strangeones), " $places-digit strange numbers with the most significant digit $fixedstart.\n")
end

countstrange(10)
@time countstrange(10)
