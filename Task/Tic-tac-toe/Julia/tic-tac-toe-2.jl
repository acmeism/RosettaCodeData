# the functions provided above are mandatory

function result_distribution(moves::TTT, casts::Dict{Role, Player})
    w = winner(moves)
    distribution = Dict(p => 0//1 for p in instances(Role))
    if w ≠ N
        distribution[w] = 1//1
        return 1, 1, distribution
    elseif length(moves) == 9
        distribution[N] = 1//1
        return 0, 1, distribution
    else
        scores = [result_distribution([moves; move], casts)
            for move in setdiff(1:9, moves)]
        maxscore = maximum(s[1] for s in scores)
        p = role(length(moves)+1)
        casts[p] isa NegamaxBot && filter!(s -> s[1] == maxscore, scores)
        n = length(scores)
        distribution = Dict(p => sum(s[3][p] for s in scores) // n for p in instances(Role))
        return -maxscore, sum(s[2] for s in scores), distribution
    end
end

function bot_statistics()
    casts = [RandomBot(), NegamaxBot()]
    combinations = Dict{Role, Player}[Dict(X => x, O => o) for x in casts for o in casts]
    println("--------------------------------------------------------------")
    println("      as X - as O       |  games |   draws    X wins    O wins")
    println("--------------------------------------------------------------")
    for combi in combinations
        distrib = result_distribution(Int[], combi)
        print("$(lpad(combi[X], 10)) - $(rpad(combi[O], 10)) | ", lpad(distrib[2], 6), " | ")
        for role in [N, X, O]
            print(" $(lpad(round(100 * distrib[3][role], digits=1), 5))%   ")
        end
        println()
    end
    println("--------------------------------------------------------------")
end

bot_statistics()
