function picknk{T<:Integer}(lo::T, hi::T)
    n = rand(lo:hi)
    k = rand(1:n)
    return (n, k)
end

nsamp = 10

print("Tests of the combinations (⊞) and permutations (⊠) operators for ")
println("integer values.")
println()
lo, hi = 1, 12
print(nsamp, " samples of n ⊠ k with n in [", lo, ", ", hi, "] ")
println("and k in [1, n].")
for i in 1:nsamp
    (n, k) = picknk(lo, hi)
    println(@sprintf "    %2d ⊠ %2d = %18d" n k n ⊠ k)
end

lo, hi = 10, 60
println()
print(nsamp, " samples of n ⊞ k with n in [", lo, ", ", hi, "] ")
println("and k in [1, n].")
for i in 1:nsamp
    (n, k) = picknk(lo, hi)
    println(@sprintf "    %2d ⊞ %2d = %18d" n k n ⊞ k)
end

println()
print("Tests of the combinations (⊞) and permutations (⊠) operators for ")
println("(big) float values.")
println()
lo, hi = 5, 15000
print(nsamp, " samples of n ⊠ k with n in [", lo, ", ", hi, "] ")
println("and k in [1, n].")
for i in 1:nsamp
    (n, k) = picknk(lo, hi)
    n = BigFloat(n)
    k = BigFloat(k)
    println(@sprintf "    %7.1f ⊠ %7.1f = %10.6e" n k n ⊠ k)
end

lo, hi = 100, 1000
println()
print(nsamp, " samples of n ⊞ k with n in [", lo, ", ", hi, "] ")
println("and k in [1, n].")
for i in 1:nsamp
    (n, k) = picknk(lo, hi)
    n = BigFloat(n)
    k = BigFloat(k)
    println(@sprintf "    %7.1f ⊞ %7.1f = %10.6e" n k n ⊞ k)
end
