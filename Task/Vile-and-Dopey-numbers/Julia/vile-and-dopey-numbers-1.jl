isvile(n) = iseven(trailing_zeros(n))
isdopey(n) = isodd(trailing_zeros(n))

println("First 25 Vile numbers:\n", filter(isvile, 1:100)[1:25])
println("\nFirst 25 Dopey numbers:\n", filter(isdopey, 1:100)[1:25])

println("\n   N   Viles Dopeys\n ", "_"^18)
for n in map(i -> 2<<i, 0:9)
    vilescount = count(isvile, 1:n)
    println(lpad(n, 4), lpad(vilescount, 7), lpad(n - vilescount, 7))
end
