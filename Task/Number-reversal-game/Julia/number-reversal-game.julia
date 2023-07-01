# v0.6

function numrevgame()
    l = collect(1:9)
    while issorted(l) shuffle!(l) end
    score = 0
    println("# Number reversal game")
    while !issorted(l)
        print("$l\nInsert the index up to which to revert: ")
        n = parse(Int, readline())
        reverse!(l, 1, n)
        score += 1
    end
    println("$l... You won!\nScore: $score")
    return score
end

numrevgame()
