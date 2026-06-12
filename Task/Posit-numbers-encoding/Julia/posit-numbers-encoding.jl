""" Posit floating point numbers """
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
    e = fsize < 1 ? pabs : pabs >> fsize     # Get E value, then F value next line
    f = fsize < 1 ? 1 // 1 : big"1" + (pabs & (2^fsize - 1)) // big"2"^fsize
    pw = 2^p.es * k + e                      # pw multiplier, power of 2 exponent
    return pw >= 0 ? (-1)^s * f * big"2"^pw // 1 : (-1)^s * f // big"2"^(-pw)
end

""" Get bits representation of a posit of size numbits and from a real number """
function positbits(x::Real, numbits, es)
    tindex = Int(round(log2(numbits / 8))) + 1 # choice of output type
    1 <= tindex <= 5 || error("Cannot create posit of bit size $numbits")
    T = [UInt8, UInt16, UInt32, UInt64, UInt128][tindex]
    x == 0 && return zero(T)                 # bits for 0 if 0, Inf if Inf, etc
    x in [-Inf, Inf, NaN] && return typemax(T) - typemax((signed(typemax(T))))
    s = x < 0                                # sign bit, 1 if negative
    xabs = abs(x)                            # work with abs(x)
    useed = 2^es                             # the useed
    pw = Int(floor(log2(xabs)))              # xabs =  1.bits.. * 2^pw
    k, e = divrem(pw, useed)                 # from pw = 2^p.es * k + e
    if e < 0
        k, e = k - 1, e + useed              # e must be unsigned
    end
    r = k < 0 ? -k : k + 1                   # r is number of R repetitions
    rbits = pw >= 0 ? (2^(r+1)-1) ⊻ 1 : 01   # bit pattern of R portion
    fsize = numbits - 1 - r - 1 - es         # size of F portion
    f = round((xabs / (2^pw) - 1) * 2^fsize) # f (mantissa - 1 as binary digits)
    pabs = T(f) | T(e << fsize) | T(BigInt(rbits) << (fsize + es)) # rbits | e | f
    return s ? -pabs : pabs                  # S and two's complement if negative
end

""" Construct various bit sizes of Posit """
posit8(x, es = 2) = PositType3(8, 2, positbits(x, 8, es))
posit16(x, es = 2) = PositType3(16, 2, positbits(x, 16, es))
posit32(x, es = 2) = PositType3(32, 2, positbits(x, 32, es))
posit64(x, es = 2) = PositType3(64, 2, positbits(x, 64, es))

const tests = [0, Inf, 1, -1, π, -π, 10π, -10π]

for t in tests, posit in (posit8, posit16, posit32, posit64)
    p = posit(t)
    i = signed(p.bits)
    ending = BigFloat(Rational(p))
    err = Float64(abs(t - ending))
    println("\n$t to $(p.numbits)-bit posit is $p.")
    println("This posit reinterpreted as integer is $i.")
    println("This posit as float is $ending,\n  with error $err.")
end
