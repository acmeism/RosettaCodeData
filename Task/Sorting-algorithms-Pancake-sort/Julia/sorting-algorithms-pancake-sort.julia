function pancakesort!(arr::Vector{<:Real})
    len = length(arr)
    if len < 2 return arr end
    for i in len:-1:2
        j = findmax(arr[1:i])[2]
        if i == j continue end
        arr[1:j] = reverse(arr[1:j])
        arr[1:i] = reverse(arr[1:i])
    end
    return arr
end

v = rand(-10:10, 10)
println("# unordered: $v\n -> ordered: ", pancakesort!(v))
