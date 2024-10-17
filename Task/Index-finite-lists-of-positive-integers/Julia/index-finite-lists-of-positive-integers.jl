using LinearAlgebra
LinearAlgebra.rank(x::Vector{<:Integer}) = parse(BigInt, "1a" * join(x, 'a'), base=11)
function unrank(n::Integer)
    s = ""
    while !iszero(n)
        ind = n % 11 + 1
        n ÷= 11
        s = "0123456789a"[ind:ind] * s
    end
    return parse.(Int, split(s, 'a'))[2:end]
end

v = [0, 1, 2, 3, 10, 100, 987654321]
n = rank(v)
v = unrank(n)
println("# v = $v\n -> n = $n\n -> v = $v")
