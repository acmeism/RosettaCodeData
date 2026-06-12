checksequence(pos, seq, n, minlen) =
    pos > minlen || seq[1] > n ? (minlen, 0) :
    seq[1] == n ? (pos, 1) :
    pos < minlen ? trypermutation(0, pos, seq, n, minlen) : (minlen, 0)

function trypermutation(i, pos, seq, n, minlen)
    if i > pos
        return minlen, 0
    end
    res1 = checksequence(pos + 1, pushfirst!(deepcopy(seq), seq[1] + seq[i + 1]), n, minlen)
    res2 = trypermutation(i + 1, pos, seq, n, res1[1])
    if res2[1] < res1[1]
        return res2
    elseif res2[1] == res1[1]
        return res2[1], res1[2] + res2[2]
    else
        throw("trypermutation exception: res2 head > res1 head")
    end
end

for num in [7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379]
    (minlen, nchains) = trypermutation(0, 0, [1], num, 12)
    println("N = $num\nMinimum length of chains: L(n) = $minlen")
    println("Number of minimum length Brauer chains: $nchains")
end
