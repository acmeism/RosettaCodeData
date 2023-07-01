using Primes

function ekgsequence(n, limit)
    ekg::Array{Int,1} = [1, n]
    while length(ekg) < limit
        for i in 2:2<<18
            if all(j -> j != i, ekg) && gcd(ekg[end], i) > 1
                push!(ekg, i)
                break
            end
        end
    end
    ekg
end

function convergeat(n, m, max = 100)
    ekgn = ekgsequence(n, max)
    ekgm = ekgsequence(m, max)
    for i in 3:max
        if ekgn[i] == ekgm[i] && sum(ekgn[1:i+1]) == sum(ekgm[1:i+1])
            return i
        end
    end
    warn("no converge in $max terms")
end

[println(rpad("EKG($i): ", 9), join(ekgsequence(i, 30), " ")) for i in [2, 5, 7, 9, 10]]
println("EKGs of 5 & 7 converge at term ", convergeat(5, 7))
