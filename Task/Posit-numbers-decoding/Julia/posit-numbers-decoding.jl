""" Posit number, a quotient of integers, variable size and exponent length """
struct PositType3{T<:Integer}
    numbits::UInt16
    es::UInt16
    bits::T
    PositType3(nb, ne, i) = new{typeof(i)}(UInt16(nb), UInt16(ne), i)
end

""" Convert PositType3 to Rational. See also posithub.org/docs/Posits4.pdf """
function Base.Rational(p::PositType3)
    s = signbit(signed(p.bits))              # s for S signbit, is 1 if negative
    pabs = p.bits << 1                       # Shift off signbit (adds a 0 to F at LSB)
    pabs == 0 && return s ? 1 // 0 : 0 // 1  # If p is 0, return 0 or if s 1 error
    s && (pabs = (-p.bits) << 1)             # If p is negative, flip to 2's complement
    expsign = signbit(signed(pabs))          # Exponent sign from 2nd bit now MSB
    r = expsign == 1 ? leading_ones(pabs) : leading_zeros(pabs) # r regime R size
    k = expsign ? r - 1 : -r                 # k for the exponent calculation
    pabs <<= (r + 1)                         # Shift off unwanted R bits
    pabs >>= (r + 2)                         # Shift back for E, F
    fsize = p.numbits - 1 - r - 1 - p.es     # Check how many F bits explicit
    e = fsize < 1 ? pabs : pabs >> fsize     # Get E value
    f = fsize < 1 ? 1 // 1 : 1 + (pabs & (2^fsize - 1)) // 2^fsize # Get F value
    pw = 2^p.es * k + e
    return pw >= 0 ? (-1)^s * f * big"2"^pw // 1 : (-1)^s * f // big"2"^(-pw)
end

@show Rational(PositType3(16, 3, 0b0000110111011101)) == 477 // 134217728
const tests = [
    (16, 3, 0b0000110111011101),
    (16, 3, 0b1000000000000000),
    (16, 3, 0b0000000000000000),
    (16, 1, 0b0110110010101000),
    (16, 1, 0b1001001101011000),
    (16, 2, 0b0000000000000001),
    (16, 0, 0b0111111111111111),
    (16, 6, 0b0111111111111110),
    (8, 1, 0b01000000),
    (8, 1, 0b11000000),
    (8, 1, 0b00110000),
    (8, 1, 0b00100000),
    (8, 2, 0b00000001),
    (8, 2, 0b01111111),
    (8, 7, 0b01111110),
    (32, 2, 0b00000000000000000000000000000001),
    (32, 2, 0b01111111111111111111111111111111),
    (32, 5, 0b01111111111111111111111111111110),
]

for t in tests
    r = Rational(PositType3(t...))
    println(string(t[3], base = 2, pad = t[1]), " => $r = ", float(r))
end
