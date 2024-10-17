function stemleaf{T<:Real}(a::Array{T,1}, leafsize=1)
    ls = 10^int(log10(leafsize))
    (stem, leaf) = divrem(sort(int(a/ls)), 10)
    leaf[sign(stem) .== -1] *= -1
    negzero = leaf .< 0
    if any(negzero)
        leaf[negzero] *= -1
        nz = @sprintf "%10s | " "-0"
        nz *= join(map(string, leaf[negzero]), " ")
        nz *= "\n"
        stem = stem[!negzero]
        leaf = leaf[!negzero]
    else
        nz = ""
    end
    slp = ""
    for i in stem[1]:stem[end]
        i != 0 || (slp *= nz)
        slp *= @sprintf "%10d | " i
        slp *= join(map(string, leaf[stem .== i]), " ")
        slp *= "\n"
    end
    slp *= " Leaf Unit = " * string(convert(T, ls)) * "\n"
    return slp
end
