using Printf

vandercorput(num::Integer, base::Integer) = sum(d * Float64(base) ^ -ex for (ex, d) in enumerate(digits(num, base)))

for base in 2:9
    @printf("%10s %i:", "Base", base)
    for num in 0:9 @printf("%7.3f", vandercorput(num, base)) end
    println(" [...]")
end
