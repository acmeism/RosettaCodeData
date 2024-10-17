function thuemorse(len::Int)
    rst = Vector{Int8}(len)
    rst[1] = 0
    i, imax = 2, 1
    while i ≤ len
        while i ≤ len && i ≤ 2 * imax
            rst[i] = 1 - rst[i-imax]
            i += 1
        end
        imax *= 2
    end
    return rst
end

println(join(thuemorse(100)))
