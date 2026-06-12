function charfreq(s)
    d = Dict()
    for c in s
        if haskey(d, c)
            d[c] += 1
        else
            d[c] = 1
        end
    end
    d
end

function charcumfreq(dfreq)
    lastval = 0
    d = Dict()
    for c in sort!(collect(keys(dfreq)))
        d[c] = lastval
        lastval += dfreq[c]
    end
    d
end

function L(s, dfreq, dcumfreq)
    nbase = BigInt(length(s))
    lsum, cumprod = BigInt(0), 1
    for (i, c) in enumerate(s)
        lsum += nbase^(nbase - i) * dcumfreq[c] * cumprod
        cumprod *= dfreq[c]
    end
    lsum
end

U(l, s, dfreq) = l + prod(c -> dfreq[c], s)

function mostzeros(low, high)
    z = Int(floor(log10(high - low)))
    if z == 0
        return string(low), 0
    end
    if low <= parse(BigInt, string(high)[1:end- z - 1] * "0"^(z + 1)) <= high
        z += 1
    end
    return string(high)[1:end-z], z
end

function msgnum(s)
    dfreq = charfreq(s)
    dcumfreq = charcumfreq(dfreq)
    low = L(s, dfreq, dcumfreq)
    high = U(low, s, dfreq)
    return mostzeros(low, high), dfreq
end

function decode(encoded, fdict)
    cdict, bas = charcumfreq(fdict), sum(values(fdict))
    kys = sort!(collect(keys(cdict)))
    revdict = Dict([(cdict[k], k) for k in kys])
    lastkey = revdict[0]
    for i in 0:bas
        if !haskey(revdict, i)
            revdict[i] = lastkey
        else
            lastkey = revdict[i]
        end
    end
    rem = parse(BigInt, encoded)
    s = ""
    for i in 1:bas
        basepow = BigInt(bas)^(bas -i)
        c = revdict[div(rem, basepow)]
        s *= c
        rem = div(rem - basepow * cdict[c], fdict[c])
    end
    s
end

for s in ["DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"]
    (encoded, z), dfreq = msgnum(s)
    println(lpad(s, 30), "  ", rpad(encoded, 19), " * 10^", rpad(z, 4), "  ",
        decode(encoded * "0"^z, dfreq))
end
