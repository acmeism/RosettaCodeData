function missingperm2(arr::Vector)
    len = length(arr[1])
    xorval = zeros(UInt8, len)
    for perm in [Vector{UInt8}(s) for s in arr], i in 1:len
        xorval[i] ⊻= perm[i]
    end
    return String(xorval)
end

@show missingperm(arr)
@show missingperm1(arr)
@show missingperm2(arr)

@btime missingperm(arr)
@btime missingperm1(arr)
@btime missingperm2(arr)
