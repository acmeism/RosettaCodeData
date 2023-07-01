function mcnuggets(max)
    b = BitSet(1:max)
    for i in 0:6:max, j in 0:9:max, k in 0:20:max
        delete!(b, i + j + k)
    end
    maximum(b)
end

println(mcnuggets(100))
