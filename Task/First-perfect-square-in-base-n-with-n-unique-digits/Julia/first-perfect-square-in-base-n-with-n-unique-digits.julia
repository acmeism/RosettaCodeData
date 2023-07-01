const num = "0123456789abcdef"
hasallin(n, nums, b) = (s = string(n, base=b); all(x -> occursin(x, s), nums))

function squaresearch(base)
    basenumerals = [c for c in num[1:base]]
    highest = parse(Int, "10" * num[3:base], base=base)
    for n in Int(trunc(sqrt(highest))):highest
        if hasallin(n * n, basenumerals, base)
            return n
        end
    end
end

println("Base     Root   N")
for b in 2:16
    n = squaresearch(b)
    println(lpad(b, 3), lpad(string(n, base=b), 10), "  ", string(n * n, base=b))
end
