function bogosort!(arr::AbstractVector)
    while !issorted(arr)
        shuffle!(arr)
    end
    return arr
end

v = rand(-10:10, 10)
println("# unordered: $v\n -> ordered: ", bogosort!(v))
