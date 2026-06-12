""" Golomb-Rice encoding of a positive number to bit vector using M of 2^k"""
function rice_encode(n::Integer, k = 2)
    @assert n >= 0
    m = 2^k
    q, r = divrem(n, m)
    return [fill(true, q); false; Bool.(reverse(digits(r, base=2, pad=k)))]
end
""" see wikipedia.org/wiki/Golomb_coding#Use_with_signed_integers """
extended_rice_encode(n, k = 2) = rice_encode(n < 0 ? -2n - 1 : 2n, k)

""" Golomb-Rice decoding of a vector of bits with M of 2^k """
function rice_decode(a::Vector{Bool}, k = 2)
    m = 2^k
    zpos = something(findfirst(==(0), a), 1)
    r = evalpoly(2, reverse(a[zpos:end]))
    q = zpos - 1
    return q * m + r
end
extended_rice_decode(a, k = 2) = (i = rice_decode(a, k); isodd(i) ? -((i + 1) ÷ 2) : i ÷ 2)

println("Base Rice Coding:")
for n in 0:10
    println(n, " -> ", join(map(d -> d ? "1" : "0", rice_encode(n))),
       " -> ", rice_decode(rice_encode(n)))
end
println("Extended Rice Coding:")
for n in -10:10
    println(n, " -> ", join(map(d -> d ? "1" : "0", extended_rice_encode(n))),
       " -> ", extended_rice_decode(extended_rice_encode(n)))
end
