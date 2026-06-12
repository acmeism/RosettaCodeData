using Main.Bits

# Using the built-in functions `leading_zeros` and `trailing_zeros`
println("# 64 bits integers:")
@printf(" %-18s | %-64s | %-2s | %-2s\n", "number", "bit representation", "lwb", "upb")
for n in 42 .^ (0:11)
    @printf(" %-18i | %-64s | %-3i | %-3i\n", n, bits(n), lwb(n), upb(n))
end

println("\n# 128 bits integers:")
@printf(" %-40s | %-2s | %-2s\n", "number", "lwb", "upb")
for n in int128"1302" .^ (0:11)
    @printf(" %-40i | %-3i | %-3i\n", n, lwb(n), upb(n))
end
