const COLORS = ["red", "white", "blue"]

function dutchsort!(a::Array{ASCIIString,1}, lo=COLORS[1], hi=COLORS[end])
    i = 1
    j = 1
    n = length(a)
    while j <= n
        if a[j] == lo
            a[i], a[j] = a[j], a[i]
            i += 1
            j += 1
        elseif a[j] == hi
            a[j], a[n] = a[n], a[j]
            n -= 1
        else
            j += 1
        end
    end
    return a
end

function dutchsort(a::Array{ASCIIString,1}, lo=COLORS[1], hi=COLORS[end])
    dutchsort!(copy(a), lo, hi)
end
