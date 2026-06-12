using Primes

function squareprimegaps(limit)
    pri = primes(limit)
    squares = Set([1; [x * x for x in 2:2:100]])
    diffs = [pri[i] - pri[i - 1] for i in 2:length(pri)]
    squarediffs = sort(unique(filter(n -> n in squares, diffs)))
    println("\n\nSquare prime gaps to $limit:")
    for sq in squarediffs
        i = findfirst(x -> x == sq, diffs)
        n = count(x -> x == sq, diffs)
        if limit == 1000000 && sq > 36
            println("Showing all $n with square difference $sq:")
            pairs = [(pri[i], pri[i + 1]) for i in findall(x -> x == sq, diffs)]
            foreach(p -> print(last(p), first(p) % 4 == 0 ? "\n" : " "), enumerate(pairs))
        else
            println("Square difference $sq: $n found. Example: ($(pri[i]), $(pri[i + 1])).")
        end
    end
end

squareprimegaps(1_000_000)
squareprimegaps(10_000_000_000)

