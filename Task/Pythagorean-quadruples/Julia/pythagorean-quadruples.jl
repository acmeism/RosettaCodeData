function quadruples(N::Int=2200)
    r  = falses(N)
    ab = falses(2N ^ 2)

    for a in 1:N, b in a:N
        ab[a ^ 2 + b ^ 2] = true
    end

    s = 3
    for c in 1:N
        s1, s, s2 = s, s + 2, s + 2
        for d in c+1:N
            if ab[s1] r[d] = true end
            s1 += s2
            s2 += 2
        end
    end

    return findall(!, r)
end

println("Pythagorean quadruples up to 2200: ", join(quadruples(), ", "))
