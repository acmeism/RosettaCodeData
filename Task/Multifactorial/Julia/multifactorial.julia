using Printf

function multifact(n::Integer, k::Integer)
    n > 0 && k > 0 || throw(DomainError())
    k > 1 || factorial(n)
    return prod(n:-k:2)
end

const khi = 5
const nhi = 10
println("Showing multifactorial for n in [1, $nhi] and k in [1, $khi].")
for k = 1:khi
    a = multifact.(1:nhi, k)
    lab = "n" * "!" ^ k
    @printf("  %-6s →  %s\n", lab, a)
end
