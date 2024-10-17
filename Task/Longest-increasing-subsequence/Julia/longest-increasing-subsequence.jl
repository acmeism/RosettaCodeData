function lis(arr::Vector)
    if length(arr) == 0 return copy(arr) end
    L = Vector{typeof(arr)}(length(arr))
    L[1] = [arr[1]]

    for i in 2:length(arr)
        nextL = []
        for j in 1:i
            if arr[j] < arr[i] && length(L[j]) ≥ length(nextL)
                nextL = L[j]
            end
        end
        L[i] = vcat(nextL, arr[i])
    end

    return L[indmax(length.(L))]
end

@show lis([3, 2, 6, 4, 5, 1])
@show lis([0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15])
