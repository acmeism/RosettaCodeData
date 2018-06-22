function mergesort(arr::Vector)
    if length(arr) ≤ 1 return arr end
    mid = length(arr) ÷ 2
    lpart = mergesort(arr[1:mid])
    rpart = mergesort(arr[mid+1:end])
    rst = similar(arr)
    i = ri = li = 1
    @inbounds while li ≤ length(lpart) && ri ≤ length(rpart)
        if lpart[li] ≤ rpart[ri]
            rst[i] = lpart[li]
            li += 1
        else
            rst[i] = rpart[ri]
            ri += 1
        end
        i += 1
    end
    if li ≤ length(lpart)
        copy!(rst, i, lpart, li)
    else
        copy!(rst, i, rpart, ri)
    end
    return rst
end

v = rand(-10:10, 10)
println("# unordered: $v\n -> ordered: ", mergesort(v))
