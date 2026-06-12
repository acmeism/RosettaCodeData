function sattolocycle!(arr::Array, last::Int=length(arr))
    for i in last:-1:2
        j = rand(1:i-1)
        arr[i], arr[j] = arr[j], arr[i]
    end
    return arr
end

@show sattolocycle!([])
@show sattolocycle!([10])
@show sattolocycle!([10, 20, 30])
@show sattolocycle!([11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22])
