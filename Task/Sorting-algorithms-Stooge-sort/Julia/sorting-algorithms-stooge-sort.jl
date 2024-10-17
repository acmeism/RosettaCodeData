function stoogesort!(a::Array, i::Int=1, j::Int=length(a))
    if a[j] < a[i]
        a[[i, j]] = a[[j, i]];
    end

    if (j - i) > 1
        t = round(Int, (j - i + 1) / 3)
        a = stoogesort!(a, i,     j - t)
        a = stoogesort!(a, i + t, j)
        a = stoogesort!(a, i,     j - t)
    end

    return a
end

x = randn(10)
@show x stoogesort!(x)
