""" Given nonnegative integer n and base b, return hereditary representation consisting of
    tuples (j, k) such that the sum of all (j * base^(evaluate(k)) = n.
"""
function decompose(n, b)
    if n < b
        return n
    end
    decomp = Vector{Union{typeof(n), Vector}}[]
    e = typeof(n)(0)
    while n != 0
        n, r = divrem(n, b)
        if r > 0
            push!(decomp, [r, decompose(e, b)])
        end
        e += 1
    end
    return decomp
end

""" Evaluate hereditary representation d under base b """
evaluate(d, b) = d isa Integer ? d : sum(j * b ^ evaluate(k, b) for (j, k) in d)

""" Return a vector of up to limitlength values of the Goodstein sequence for n """
function goodstein(n, limitlength = 10)
    seq = typeof(n)[]
    b = typeof(n)(2)
    while length(seq) < limitlength
        push!(seq, n)
        n == 0 && break
        d = decompose(n, b)
        b += 1
        n = evaluate(d, b) - 1
    end
    return seq
end

"""Get the Nth term of Goodstein(n) sequence counting from 0, see https://oeis.org/A266201"""
A266201(n) = last(goodstein(BigInt(n), n + 1))

println("Goodstein(n) sequence (first 10) for values of n from 0 through 7:")
for i in 1:7
    println("Goodstein of $i: $(goodstein(i))")
end
println("\nThe Nth term of Goodstein(N) sequence counting from 0, for values of N from 0 through 16:")
for i in big"1":16
    println("Term $i of Goodstein($i}): $(A266201(i))")
end
