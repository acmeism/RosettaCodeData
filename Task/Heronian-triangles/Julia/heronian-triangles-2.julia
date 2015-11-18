slim = 200

ht = IntegerTriangle[]

for a in 1:slim, b in a:slim, c in b:slim
    isprimheronian(a, b, c) || continue
    push!(ht, IntegerTriangle(a, b, c))
end

sort!(ht, by=x->(x.σ, x.p, x.c))

print("The number of primitive Hernonian triangles having sides ≤ ")
println(slim, " is ", length(ht))

tlim = 10
tlim = min(tlim, length(ht))

println()
println("Tabulating the first (by σ, p, c) ", tlim, " of these:")
println("    a   b   c    σ    p")
for t in ht[1:tlim]
    println(@sprintf "%6d %3d %3d %4d %4d" t.a t.b t.c t.σ t.p)
end

tlim = 210
println()
println("Tabulating those having σ = ", tlim, ":")
println("    a   b   c    σ    p")
for t in ht
    t.σ == tlim || continue
    t.σ == tlim || break
    println(@sprintf "%6d %3d %3d %4d %4d" t.a t.b t.c t.σ t.p)
end
