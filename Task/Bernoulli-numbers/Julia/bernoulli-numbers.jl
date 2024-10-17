function bernoulli(n)
    A = Vector{Rational{BigInt}}(undef, n + 1)
    for m = 0 : n
        A[m + 1] = 1 // (m + 1)
        for j = m : -1 : 1
            A[j] = j * (A[j] - A[j + 1])
        end
    end
    return A[1]
end

function display(n)
    B = map(bernoulli, 0 : n)
    pad = mapreduce(x -> ndigits(numerator(x)) + Int(x < 0), max, B)
    argdigits = ndigits(n)
    for i = 0 : n
        if numerator(B[i + 1]) & 1 == 1
            println(
                "B(", lpad(i, argdigits), ") = ",
                lpad(numerator(B[i + 1]), pad), " / ", denominator(B[i + 1])
            )
        end
    end
end

display(60)

# Alternative: Following the comment in the Perl section it is much more efficient
# to compute the list of numbers instead of one number after the other.

function BernoulliList(len)
    A = Vector{Rational{BigInt}}(undef, len + 1)
    B = similar(A)
    for n in 0 : len
        A[n + 1] = 1 // (n + 1)
        for j = n : -1 : 1
            A[j] = j * (A[j] - A[j + 1])
        end
        B[n + 1] =  A[1]
    end
    return B
end

for (n, b) in enumerate(BernoulliList(60))
    isodd(numerator(b)) && println("B($(n-1)) = $b")
end
