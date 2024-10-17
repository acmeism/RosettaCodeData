module LongMultiplication

using Compat

function addwithcarry!(r, addend, addendpos)
    while true
        pad = max(0, addendpos - lastindex(r))
        append!(r, fill(0, pad))
        addendrst = addend + r[addendpos]
        addend, r[addendpos] = divrem(addendrst, 10)
        iszero(addend) && break
        addendpos += 1
    end
    return r
end

function longmult(mult1::AbstractVector{T}, mult2::AbstractVector{T}) where T <: Integer
    r = T[]
    for (offset1, digit1) in enumerate(mult1), (offset2, digit2) in zip(eachindex(mult2) + offset1 - 1, mult2)
        single_multrst = digits(digit1 * digit2)
        for (addoffset, rstdigit) in zip(eachindex(single_multrst) + offset2 - 1, single_multrst)
            addwithcarry!(r, rstdigit, addoffset)
        end
    end
    return r
end

function longmult(a::T, b::T)::T where T <: Integer
    mult1 = digits(a)
    mult2 = digits(b)
    r = longmult(mult1, mult2)
    return sum(d * T(10) ^ (e - 1) for (e, d) in enumerate(r))
end

function longmult(a::AbstractString, b::AbstractString)
    if !ismatch(r"^\d+", a) || !ismatch(r"^\d+", b)
        throw(ArgumentError("string must contain only digits"))
    end
    mult1 = reverse(collect(Char, a) .- '0')
    mult2 = reverse(collect(Char, b) .- '0')
    r = longmult(mult1, mult2)
    return reverse(join(r))
end

end  # module LongMultiplication
