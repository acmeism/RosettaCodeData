function negbase(n, b)
    if n == 0 return "0" end
    out = IOBuffer()
    while n != 0
        n, r = divrem(n, b)
        if r < 0
            n += 1
            r -= b
        end
        print(out, r)
    end
    return reverse(String(out))
end

invnegbase(nst, b) = sum((ch - '0') * b ^ (i - 1) for (i, ch) in enumerate(reverse(nst)))

testset = Dict(
    (10, -2) => "11110",
    (143, -3) => "21102",
    (15, -10) => "195")

for ((num, base), rst) in testset
    encoded = negbase(num, base)
    decoded = invnegbase(encoded, base)
    println("\nencode $num in base $base:\n-> expected: $rst\n-> resulted: $encoded\n-> decoded: $decoded")
end
