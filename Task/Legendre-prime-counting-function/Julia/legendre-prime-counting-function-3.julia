function countprimes(n)
    n < 3 && return typeof(n)(n > 1)
    rtlmt = isqrt(n)
    mxndx = (rtlmt - 1) ÷ 2
    smalls::Array{UInt32} = [i for i in 0:mxndx+1]
    roughs::Array{UInt32} = [i + i + 1 for i in 0:mxndx+1]
    larges::Array{Int64} = [(n ÷ (i + i + 1) - 1) ÷ 2 for i in 0:mxndx+1]
    cmpsts = falses(mxndx + 1)
    bp, npc, mxri = 3, 0, mxndx
    @inbounds while true
        i = bp >> 1
        sqri = (i + i) * (i + 1)
        sqri > mxndx && break
        if !cmpsts[i + 1]
           cmpsts[i + 1] = true
            for c in sqri:bp:mxndx
                cmpsts[c + 1] = true
            end
            ri = 0
            for k in 0:mxri
                q = roughs[k + 1]
                qi = q >> 1
                cmpsts[qi + 1] && continue
                d = UInt64(bp) * UInt64(q)
                larges[ri + 1] = larges[k + 1] + npc -
                  (d <= rtlmt ? larges[smalls[d >> 1 + 1] - npc + 1]
                              : smalls[(Int(floor(n / d)) - 1) >> 1 + 1])
                roughs[ri + 1] = q
                ri += 1
            end
            m = mxndx
            @simd for k in (rtlmt ÷ bp - 1) | 1 : -2 : bp
                c = smalls[k >> 1 + 1] - npc
                ee = (k * bp) >> 1
                while m >= ee
                    smalls[m + 1] -= c
                    m -= 1
                end
            end
            mxri = ri - 1
            npc += 1
        end
        bp += 2
    end

    result = larges[1]
    @simd for i in 2:mxri+1
        result -= larges[i]
    end
    result += (mxri + 1 + 2 * (npc - 1)) * mxri ÷ 2

    for j in 1:mxri
        p = UInt64(roughs[j + 1])
        m = n ÷ p
        ee = smalls[(Int(floor(m / p)) - 1) >> 1 + 1] - npc
        ee <= j && break
        for k in j+1:ee
            result += smalls[(Int(floor(m / roughs[k + 1])) - 1) >> 1 + 1]
        end
        result -= (ee - j) * (npc + j - 1)
    end
    return result + 1
end

for i in 0:14
    println("π(10^$i) = ", countprimes(10^i))
end

@time countprimes(10^13)
@time countprimes(10^14)
