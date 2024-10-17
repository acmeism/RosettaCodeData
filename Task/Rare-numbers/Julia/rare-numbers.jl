using Formatting, Printf

struct Term
    coeff::UInt64
    ix1::Int8
    ix2::Int8
end

function toUInt64(dgits, reverse)
    return reverse ? foldr((i, j) -> i + 10j, UInt64.(dgits)) :
                     foldl((i, j) -> 10i + j, UInt64.(dgits))
end

function issquare(n)
    if 0x202021202030213 & (1 << (UInt64(n) & 63)) != 0
        root = UInt64(floor(sqrt(n)))
        return root * root == n
    end
    return false
end

seq(from, to, step) = Int8.(collect(from:step:to))

commatize(n::Integer) = format(n, commas=true)

const verbose = true
const count = [0]

"""
Recursive closure to generate (n+r) candidates from (n-r) candidates
and hence find Rare numbers with a given number of digits.
"""
function fnpr(cand, di, dis, indices, nmr, nd, level, dgits, fml, dmd, start, rares, il)
    if level == length(dis)
        dgits[indices[1][1] + 1] = fml[cand[1]][di[1] + 1][1]
        dgits[indices[1][2] + 1] = fml[cand[1]][di[1] + 1][2]
        le = length(di)
        if nd % 2 == 1
            le -= 1
            dgits[nd ÷ 2 + 1] = di[le + 1]
        end
        for (i, d) in enumerate(di[2:le])
            dgits[indices[i+1][1] + 1] = dmd[cand[i+1]][d + 1][1]
            dgits[indices[i+1][2] + 1] = dmd[cand[i+1]][d + 1][2]
        end
        r = toUInt64(dgits, true)
        npr = nmr + 2 * r
        !issquare(npr) && return
        count[1] += 1
        verbose && @printf("     R/N %2d:", count[1])
        !verbose && print("$count rares\b\b\b\b\b\b\b\b\b")
        ms = UInt64(time() * 1000 - start)
        verbose && @printf("  %9s ms", commatize(Int(ms)))
        n = toUInt64(dgits, false)
        verbose && @printf("  (%s)\n", commatize(BigInt(n)))
        push!(rares, n)
    else
        for num in dis[level + 1]
            di[level + 1] = num
            fnpr(cand, di, dis, indices, nmr, nd, level + 1, dgits, fml, dmd, start, rares, il)
        end
    end
end # function fnpr

# Recursive closure to generate (n-r) candidates with a given number of digits.
# var fnmr func(cand []int8, list [][]int8, indices [][2]int8, nd, level int)
function fnmr(cand, list, indices, nd, level, allterms, fml, dmd, dgits, start, rares, il)
    if level == length(list)
        nmr, nmr2 = zero(UInt64), zero(UInt64)
        for (i, t) in enumerate(allterms[nd - 1])
            if cand[i] >= 0
                nmr += t.coeff * UInt64(cand[i])
            else
                nmr2 += t.coeff * UInt64(-cand[i])
                if nmr >= nmr2
                    nmr -= nmr2
                    nmr2 = zero(nmr2)
                else
                    nmr2 -= nmr
                    nmr = zero(nmr)
                end
            end
        end
        nmr2 >= nmr && return
        nmr -= nmr2
        !issquare(nmr) && return
        dis = [[seq(0, Int8(length(fml[cand[1]]) - 1), 1)] ;
            [seq(0, Int8(length(dmd[c]) - 1), 1) for c in cand[2:end]]]
        isodd(nd) && push!(dis, il)
        di = zeros(Int8, length(dis))
        fnpr(cand, di, dis, indices, nmr, nd, 0, dgits, fml, dmd, start, rares, il)
    else
        for num in list[level + 1]
            cand[level + 1] = num
            fnmr(cand, list, indices, nd, level + 1, allterms, fml, dmd, dgits, start, rares, il)
        end
    end
end # function fnmr

function findrare(maxdigits = 19)
    start = time() * 1000.0
    pow = one(UInt64)
    verbose && println("Aggregate timings to process all numbers up to:")
    # terms of (n-r) expression for number of digits from 2 to maxdigits
    allterms = Vector{Vector{Term}}()
    for r in 2:maxdigits
        terms = Term[]
        pow *= 10
        pow1, pow2, i1, i2 = pow, one(UInt64), zero(Int8), Int8(r - 1)
        while i1 < i2
            push!(terms, Term(pow1 - pow2, i1, i2))
            pow1, pow2, i1, i2 = pow1 ÷ 10, pow2 * 10, i1 + 1, i2 - 1
        end
        push!(allterms, terms)
    end
    #  map of first minus last digits for 'n' to pairs giving this value
    fml = Dict(
        0 => [2 => 2, 8 => 8],
        1 => [6 => 5, 8 => 7],
        4 => [4 => 0],
        6 => [6 => 0, 8 => 2],
    )
    # map of other digit differences for 'n' to pairs giving this value
    dmd = Dict{Int8, Vector{Vector{Int8}}}()
    for i in 0:99
        a = [Int8(i ÷ 10), Int8(i % 10)]
        d = a[1] - a[2]
        v = get!(dmd, d, [])
        push!(v, a)
    end
    fl = Int8[0, 1, 4, 6]
    dl = seq(-9, 9, 1)  # all differences
    zl = Int8[0]        # zero differences only
    el = seq(-8, 8, 2)  # even differences only
    ol = seq(-9, 9, 2)  # odd differences only
    il = seq(0, 9, 1)
    rares = UInt64[]
    lists = [[[f]] for f in fl]
    dgits = Int8[]
    count[1] = 0

    for nd = 2:maxdigits
        dgits = zeros(Int8, nd)
        if nd == 4
            push!(lists[1], zl)
            push!(lists[2], ol)
            push!(lists[3], el)
            push!(lists[4], ol)
        elseif length(allterms[nd - 1]) > length(lists[1])
            for i in 1:4
                push!(lists[i], dl)
            end
        end
        indices = Vector{Vector{Int8}}()
        for t in allterms[nd - 1]
            push!(indices, Int8[t.ix1, t.ix2])
        end
        for list in lists
            cand = zeros(Int8, length(list))
            fnmr(cand, list, indices, nd, 0, allterms, fml, dmd, dgits, start, rares, il)
        end
        ms = UInt64(time() * 1000 - start)
        verbose && @printf("  %2d digits:  %9s ms\n", nd, commatize(Int(ms)))
    end

    sort!(rares)
    @printf("\nThe rare numbers with up to %d digits are:\n", maxdigits)
    for (i, rare) in enumerate(rares)
        @printf("  %2d:  %25s\n", i, commatize(BigInt(rare)))
    end
end # findrare function

findrare()
