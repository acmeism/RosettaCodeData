function aliquotclassifier{T<:Integer}(n::T)
    a = T[n]
    b = divisorsum(a[end])
    len = 1
    while len < 17 && !(b in a) && 0 < b && b < 2^47+1
        push!(a, b)
        b = divisorsum(a[end])
        len += 1
    end
    if b in a
        1 < len || return ("Perfect", a)
        if b == a[1]
            2 < len || return ("Amicable", a)
            return ("Sociable", a)
        elseif b == a[end]
            return ("Aspiring", a)
        else
            return ("Cyclic", push!(a, b))
        end
    end
    push!(a, b)
    b != 0 || return ("Terminating", a)
    return ("Non-terminating", a)
end
