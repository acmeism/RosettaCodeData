using Printf

function digitalmultroot(n::S, bs::T = 10) where {S <: Integer, T <: Integer}
    -1 < n && 1 < bs || throw(DomainError())
    ds = n
    pers = 0
    while bs <= ds
        ds = prod(digits(ds, base = bs))
        pers += 1
    end
    return (pers, ds)
end


function testdigitalmultroot(bs = 10, excnt = 5)
    println("Testing Multiplicative Digital Root.\n")
    for i in [123321, 7739, 893, 899998]
        (pers, ds) = digitalmultroot(i)
        print(@sprintf("%8d", i))
        print(" has persistence ", pers)
        println(" and digital root ", ds)
    end

    dmr = zeros(Int, bs, excnt)
    hasroom = trues(bs)
    dex = ones(Int, bs)
    i = 0
    while any(hasroom)
        _, ds = digitalmultroot(i, bs)
        ds += 1
        if hasroom[ds]
            dmr[ds, dex[ds]] = i
            dex[ds] += 1
            if dex[ds] > excnt
                hasroom[ds] = false
            end
        end
        i += 1
    end

    println("\n MDR:    First ", excnt, " numbers having this MDR")
    for (i, d) in enumerate(0:(bs-1))
        print(@sprintf("%4d: ", d))
        println(join([@sprintf("%6d", dmr[i, j]) for j in 1:excnt], ","))
    end
end

testdigitalmultroot()
