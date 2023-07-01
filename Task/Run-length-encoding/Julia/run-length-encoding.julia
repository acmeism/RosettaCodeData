using IterTools

encode(str::String) = collect((length(g), first(g)) for g in groupby(first, str))
decode(cod::Vector) = join(repeat("$l", n) for (n, l) in cod)

for original in ["aaaaahhhhhhmmmmmmmuiiiiiiiaaaaaa", "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"]
    encoded = encode(original)
    decoded = decode(encoded)
    println("Original: $original\n -> encoded: $encoded\n -> decoded: $decoded")
end
