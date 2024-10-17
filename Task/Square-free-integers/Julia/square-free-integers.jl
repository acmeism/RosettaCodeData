using Primes

const maxrootprime = Int64(floor(sqrt(1000000000145)))
const sqprimes = map(x -> x * x, primes(2, maxrootprime))
possdivisorsfor(n) = vcat(filter(x -> x <= n / 2, sqprimes), n in sqprimes ? n : [])
issquarefree(n) = all(x -> floor(n / x) != n / x, possdivisorsfor(n))

function squarefreebetween(mn, mx)
    count = 1
    padsize = length(string(mx)) + 2
    println("The squarefree numbers between $mn and $mx are:")
    for n in mn:mx
        if issquarefree(n)
            print(lpad(string(n), padsize))
            count += 1
        end
        if count * padsize > 80
            println()
            count = 1
        end
    end
    println()
end

function squarefreecount(intervals, maxnum)
    count = 0
    for n in 1:maxnum
        for i in 1:length(intervals)
            if intervals[i] < n
                println("There are $count square free numbers between 1 and $(intervals[i]).")
                intervals[i] = maxnum + 1
            end
        end
        if issquarefree(n)
            count += 1
        end
    end
    println("There are $count square free numbers between 1 and $maxnum.")
end

squarefreebetween(1, 145)
squarefreebetween(1000000000000, 1000000000145)
squarefreecount([100, 1000, 10000, 100000], 1000000)
