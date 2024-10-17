function maxconcat(arr::Vector{<:Integer})
    b = sort(string.(arr); lt=(x, y) -> x * y < y * x, rev=true) |> join
    return try parse(Int, b) catch parse(BigInt, b) end
end

tests = ([1, 34, 3, 98, 9, 76, 45, 4],
         [54, 546, 548, 60],
         [1, 34, 3, 98, 9, 76, 45, 4, 54, 546, 548, 60])

for arr in tests
    println("Max concatenating in $arr:\n -> ", maxconcat(arr))
end
