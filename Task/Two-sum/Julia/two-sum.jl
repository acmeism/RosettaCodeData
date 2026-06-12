function twosum(v::Vector, s)
    i = 1
    j = length(v)
    while i < j
        if v[i] + v[j] == s
            return [i, j]
        elseif v[i] + v[j] < s
            i += 1
        else
            j -= 1
        end
    end
    return similar(v, 0)
end

@show twosum([0, 2, 11, 19, 90], 21)
