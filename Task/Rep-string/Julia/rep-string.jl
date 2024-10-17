function repstring(r::AbstractString)
    n = length(r)
    replst = String[]
    for m in 1:n÷2
        s = r[1:chr2ind(r, m)]
        if (s ^ cld(n, m))[1:chr2ind(r, n)] != r continue end
        push!(replst, s)
    end
    return replst
end

tests = ["1001110011", "1110111011", "0010010010", "1010101010", "1111111111",
         "0100101101", "0100100", "101", "11", "00", "1",
         "\u2200\u2203\u2200\u2203\u2200\u2203\u2200\u2203"]

for r in tests
    replst = repstring(r)
    if isempty(replst)
        println("$r is not a rep-string.")
    else
        println("$r is a rep-string of ", join(replst, ", "), ".")
    end
end
