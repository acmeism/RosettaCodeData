using Primes

function testormistons(toshow = 30, lim = 1_000_000)
    pri = primes(lim)
    csort = [sort!(collect(string(i))) for i in pri]
    ormistons = [(pri[i - 1], pri[i]) for i in 2:lastindex(pri) if csort[i - 1] == csort[i]]
    println("First $toshow Ormiston pairs under $lim:")
    for (i, o) in enumerate(ormistons)
        i > toshow && break
        print("(", lpad(first(o), 6), lpad(last(o), 6), " )", i % 5 == 0 ? "\n" : "  ")
    end
    println("\n", length(ormistons), " is the count of Ormiston pairs up to one million.")
end

testormistons()
