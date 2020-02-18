using Printf
S = subtypes(Signed)
U = subtypes(Unsigned)

println("Integer limits:")
for (s, u) in zip(S, U)
    @printf("%8s: [%s, %s]\n", s, typemin(s), typemax(s))
    @printf("%8s: [%s, %s]\n", u, typemin(u), typemax(u))
end
