function alluniquehead(arr)
    len = length(arr)
    if len > 1
        for i in 2:len
            if arr[i] in @view arr[1:i-1]
                return arr[1:i-1]
            end
        end
    end
    return arr[:]
end

function maxuniques(arr)
    length(arr) < 2 && return arr
    amax = [alluniquehead(@view arr[i:end]) for i in 1:length(arr)]
    maxlen = maximum(map(length, amax))
    return filter(a -> length(a) == maxlen, amax)
end

for s in ["xyzyabcybdfd", "xyzyab", "zzzzz", "a", "α⊆϶α϶", "", [1, 2, 3, 4, 1, 2, 5, 6, 1, 7, 8, 1, 0]]
    uarray = maxuniques(collect(s))
    !isempty(uarray) && length(uarray[1]) > 1 && uarray[1][1] isa Char && (uarray = String.(uarray))
    println("\"$s\" => ", uarray)
end
