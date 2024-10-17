module ToyECDSA

using SHA

import Base.in, Base.==, Base.+, Base.*

export ECDSA_Key, ECDSA_Public_Key, genkey, ECDSA_sign, isverifiedECDSA

# T will be BigInt in most applications
struct CurveFP{T}
    p::T
    a::T
    b::T
    CurveFP(p, a::T, b::T) where T <: Number = new{T}(p, a, b)
end

struct PointEC{T}
    curve::CurveFP{T}
    x::T
    y::T
    order::Union{Number, Nothing}
    function PointEC(curve, x::T, y::T, order=nothing) where T <: Number
        @assert((x, y) in curve)
        new{T}(curve, x, y, order)
    end
end

struct PointINF end
const INFINITY = PointINF()

function ==(point_a::PointEC, point_b::PointEC)
    if point_a.curve == point_b.curve && point_a.x == point_b.x && point_a.y == point_b.y
        return true
    end
    return false
end

function ==(curve_a::CurveFP, curve_b::CurveFP)
    if curve_a.a == curve_b.a && curve_a.b == curve_b.b && curve_a.p == curve_b.p
        return true
    end
    return false
end

+(point_a::PointINF, point_b::PointINF) = point_b
+(point_a::PointINF, point_b::PointEC) = point_b
+(point_a::PointEC, point_b::PointINF) = point_a

function +(point_a::PointEC, point_b::PointEC)
     @assert(point_a.curve == point_b.curve)
     if point_a.x == point_b.x
         if (point_a.y + point_b.y) % point_a.curve.p == 0
             return INFINITY
         else
             return double(point_a)
        end
    end
    p = point_a.curve.p
    λ = (point_a.y - point_b.y) * invmod(point_a.x - point_b.x, p)
    xr = mod(λ * λ - point_a.x - point_b.x, p)
    yr = mod(λ * (point_a.x - xr) - point_a.y, p)
    return PointEC(point_a.curve, xr, yr, point_a.order)
end

*(point_a::PointINF, int_b::Number) = INFINITY
*(int_b::Number, point_a::PointINF) = INFINITY
*(int_b::Number, point_a::PointEC) = point_a * int_b

function *(point_a::PointEC, int_b::Number)
    leftmost_bit(x) = big"2"^Int(trunc(log(2, x)))
    if point_a.order != nothing
        int_b %= point_a.order
    end
    if int_b == 0
        return INFINITY
    end
    int_3b = 3 * int_b
    negative_a = PointEC(point_a.curve, point_a.x, -point_a.y, point_a.order)
    i = BigInt(leftmost_bit(int_3b) ÷ 2)
    result = point_a
    while i > 1
        result = double(result)
        if (int_3b & i) != 0 && (int_b & i) == 0
            result += point_a
        end
        if (int_3b & i) == 0 && (int_b & i) != 0
            result += negative_a
        end
        i ÷= 2
    end
    return result
end

in(z::Tuple, curve::CurveFP) = (z[2]^2 - (z[1]^3 + curve.a*z[1] + curve.b)) % curve.p == 0
in(x::Number,y::Number, curve::CurveFP) = (y^2 -(x^3 + curve.a*x + curve.b)) % curve.p == 0
in(p::PointEC, curve::CurveFP) = (p.y^2 - (p.x^3 + curve.a * p.x + curve.b)) % curve.p == 0
in(point::PointINF, curve::CurveFP) = true

double(point_a::PointINF) = INFINITY

function double(point_a::PointEC)
  a, p = point_a.curve.a, point_a.curve.p
  l = mod((3 * point_a.x^2 + a) * invmod(2 * point_a.y, p), p)
  x3 = mod(l^2 - 2 * point_a.x, p)
  y3 = mod(l * (point_a.x - x3) - point_a.y, p)
  return PointEC(point_a.curve, x3, y3, point_a.order)
end

const secp256k1 = (  # use the Bitcoin ECDSA curve
    p = big"0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F",
    a = big"0x0",
    b = big"0x7",
    r = big"0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141",
    Gx = big"0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798",
    Gy = big"0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8",
)
@assert((secp256k1.Gy^2 - secp256k1.Gx^3 - 7) % secp256k1.p == 0)

function generatemultiplier(stdcurve)
    return foldl((x, y) -> 16 * BigInt(x) + y, rand(0:16, ndigits(stdcurve.r - 1, base=16)))
end

struct ECDSA_Key
    E::CurveFP
    secret::BigInt
    G::PointEC
    r::BigInt
    W::PointEC
end

struct ECDSA_Public_Key
    E::CurveFP
    G::PointEC
    r::BigInt
    W::PointEC
end

function genkey(curve=secp256k1) # default: use Bitcoin standard EC curve secp256k1
    E = CurveFP(curve.p, curve.a, curve.b)
    s = generatemultiplier(curve)
    G = PointEC(E, curve.Gx, curve.Gy, curve.r)
    W = s * G
    return ECDSA_Key(E, s, G, curve.r, W)
end

aspublickey(k::ECDSA_Key) = ECDSA_Public_Key(k.E, k.G, k.r, k.W)
privatekey(k::ECDSA_Key) = k.secret

function ECDSA_sign(m::String, key::ECDSA_Key, digestfunction=sha256)
    r, f = key.r, digestfunction(codeunits(m)) # f = H(m)
    # order of curve points length must be >= sha digest length (in bytes)
    @assert(ndigits(r, base=16) >= length(f))
    c, d, bindigest = BigInt(0), BigInt(0), foldl((x, y) -> 16 * BigInt(x) + y, f)
    while c == 0 || d == 0
        u = generatemultiplier(secp256k1)
        V = u * key.G
        c = mod(V.x, r)
        d = mod((invmod(u, r) * (bindigest + key.secret * c)), r)
    end
    return aspublickey(key), c, d
end

function isverifiedECDSA(m::String, publickey, c, d, digestfunction=sha256)
    if 1 <= c < publickey.r && 1 <= d < publickey.r
        r, f = publickey.r, digestfunction(codeunits(m))
        h, bindigest = invmod(d, r), foldl((x, y) -> 16 * BigInt(x) + y, f)
        h1, h2 = mod(bindigest * h, r), mod(c * h, r)
        verifierpoint = h1 * publickey.G + h2 * publickey.W
        return mod(verifierpoint.x, r) == c
    end
    return false
end

end  # module

using .ToyECDSA

const key = genkey()
const msg = "Bill says this is an elliptic curve digital signature algorithm."
const altered = "Bill says this isn't an elliptic curve digital signature algorithm."

publickey, c, d = ECDSA_sign(msg, key)

println("ECDSA of message <$msg> verified: ", isverifiedECDSA(msg, publickey, c, d))

println("ECDSA of message <$altered> verified: ", isverifiedECDSA(altered, publickey, c, d))
