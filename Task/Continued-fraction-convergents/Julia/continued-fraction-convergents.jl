function convergents(x::Real, maxcount::T) where T <: Integer
    components = T[]
    rationals = Rational{T}[]
    for _ in 1:maxcount
        fpart, ipart = modf(x)
        push!(components, T(ipart))
        fpart == 0 && break
        x = inv(fpart)
    end
    numa, denoma, numb, denomb = T(1), T(0), T(components[begin]), T(1)
    push!(rationals, numb // denomb)
    for comp in components[begin+1:end]
        numa, denoma, numb, denomb = numb, denomb, numa + comp * numb, denoma + comp * denomb
        push!(rationals, numb // denomb)
    end
    return rationals
end

const tests = [("415/93", 415//93), ("649/200", 649//200), ("sqrt(2)", sqrt(2)),
               ("sqrt(5)", sqrt(5)), ("golden ratio", (sqrt(5) + 1) / 2)]

println("The continued fraction convergents for the following (maximum 8 terms) are:")
for (s, x) in tests
    println(lpad(s, 15), " = ", convergents(x, 8))
end
