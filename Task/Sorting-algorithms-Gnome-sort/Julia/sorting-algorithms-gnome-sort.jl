function gnomesort!(arr::Vector)
    i, j = 1, 2
    while i < length(arr)
        if arr[i] ≤ arr[i+1]
            i = j
            j += 1
        else
            arr[i], arr[i+1] = arr[i+1], arr[i]
            i -= 1
            if i == 0
                i = j
                j += 1
            end
        end
    end
    return arr
end

v = rand(-10:10, 10)
println("# unordered: $v\n -> ordered: ", gnomesort!(v))
