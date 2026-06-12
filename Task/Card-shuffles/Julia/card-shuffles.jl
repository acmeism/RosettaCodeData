function riffleshuffle!(list::Vector, flips::Integer)
    len = length(list)
    # pre-allocate the left and right part for efficiency
    llist = similar(list, len÷2 + fld(len, 10))
    rlist = similar(list, len÷2 + fld(len, 10))
    for _ in Base.OneTo(flips)
        # cut the deck at the middle +/- 10%,
        # remove the second line of the formula for perfect cutting
        cut = len ÷ 2 + rand(-1:2:1) * rand(0:fld(len, 10))

        # split the deck and copy it to left and right
        copy!(llist, 1, list, 1, cut)
        copy!(rlist, 1, list, cut + 1, len - cut)

        ind, indl, indr = len, cut, len - cut
        while indl ≥ 1 && indr ≥ 1
            if rand() < indl / 2indr
                list[ind] = llist[indl]
                indl -= 1
            else
                list[ind] = rlist[indr]
                indr -= 1
            end
            ind -= 1
        end

        copy!(list, 1, rlist, 1, indr)
        copy!(list, 1, llist, 1, indl)
    end
    return list
end

function overhandshuffle!(list::Vector, passes::Integer)
    len = length(list)
    otherhand = similar(list)
    for _ in Base.OneTo(passes)
        ind = 1
        while ind ≤ endof(list)
            chklen = min(rand(1:cld(len, 5)), len - ind + 1)
            copy!(otherhand, ind, list, len - ind - chklen + 2, chklen)
            ind += chklen
        end
        list .= otherhand
    end
    return list
end

v = collect(1:20)
println("# Riffle shuffle (1):\n", v)
println(" -> ", riffleshuffle!(v, 1), "\n")

v = collect(1:20)
println("# Riffle shuffle (10):\n", v)
println(" -> ", riffleshuffle!(v, 10), "\n")

v = collect(1:20)
println("# Overhand shuffle (1):\n", v)
println(" -> ", overhandshuffle!(v, 1), "\n")

v = collect(1:20)
println("# Overhand shuffle (10):\n", v)
println(" -> ", overhandshuffle!(v, 10), "\n")

v = collect(1:20)
println("# Default shuffle:\n", v)
println(" -> ", shuffle!(v), "\n")
