const colors = ["grey", "yellow", "green"]

function wordle(answer, guess)
    n = length(guess)
    length(answer) != n && error("The words must be of the same length.")
    answervector, result = collect(answer), zeros(Int, n)
    for i in 1:n
        if guess[i] == answervector[i]
            answervector[i] = '\0'
            result[i] = 2
        end
    end
    for i in 1:n
        c = guess[i]
        ix = findfirst(isequal(c), answervector)
        if ix != nothing
            answervector[ix] = '\0'
            result[i] = 1
        end
    end
    return result
end

const testpairs = [
    ["ALLOW", "LOLLY"],
    ["BULLY", "LOLLY"],
    ["ROBIN", "ALERT"],
    ["ROBIN", "SONIC"],
    ["ROBIN", "ROBIN"]
]
for (pair0, pair1) in testpairs
    res  = wordle(pair0, pair1)
    res2 = [colors[i + 1] for i in res]
    println("$pair0 v $pair1 => $res => $res2")
end
