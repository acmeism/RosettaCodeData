using Printf
import Base.BigInt, Base.BigFloat, Base.print, Base.+, Base.-, Base.*

abstract type BalancedBaseDigitArray end

mutable struct BalancedTernary <: BalancedBaseDigitArray
    dig::Vector{Int8}
    p::Int
    BalancedTernary(arr::Vector, i) = new(Int8.(arr), i)
end

const MAX_PRECISION = 81

function BalancedTernary(s::String)
    if (i = findfirst(x -> x == '.', s)) != nothing
        p = length(s) - i
        s = s[1:i-1] * s[i+1:end]
    else
        p = 0
    end
    b = BalancedTernary([c == '-' ? -1 : c == '0' ? 0 : 1 for c in s], p)  # 2
end

function BalancedTernary(n::Integer)                                                # 1, 3
    if n < 0
        return -BalancedTernary(-n)
    elseif n == 0
        return BalancedTernary([0], 0)
    else
        return canonicalize!(BalancedTernary(reverse(digits(n, base=3)), 0))
    end
end
BalancedTernary() = BalancedTernary(0)

function BalancedTernary(x::Real)                                             # 1, 3
    if x < 0
        return -BalancedTernary(-x)
    end
    arr = reverse(digits(BigInt(round(x * big"3.0"^MAX_PRECISION)), base=3))
    return canonicalize!(BalancedTernary(arr, MAX_PRECISION))
end

function Base.String(b::BalancedTernary)                                      # 3
    canonicalize!(b)
    s = String([['-', '0', '+'][c + 2] for c in b.dig])
    if b.p > 0
        if b.p < length(s)
            s = s[1:end-b.p] * "." * s[end-b.p+1:end]
        elseif b.p == length(s)
            s = "0." * s
        else
            s = "0." * "0"^(b.p - length(s)) * s
        end
    end
    return s
end

function BigInt(b::BalancedTernary)
    canonicalize!(b)
    if b.p > 0
        throw(InexactError("$(b.p) places after decimal point"))
    end
    return sum(t -> BigInt(3)^(t[1] - 1) * t[2], enumerate(reverse(b.dig)))          # 3
end

BigFloat(b::BalancedTernary) = BigInt(BalancedTernary(b.dig, 0)) / big"3.0"^(b.p)

function canonicalize!(b::BalancedTernary)
    for i in length(b.dig):-1:1
        if b.dig[i] > 1
            b.dig[i] -= 3
            if i == 1
                pushfirst!(b.dig, 1)
            else
                b.dig[i - 1] += 1
            end
        elseif b.dig[i] < -1
            b.dig[i] += 3
            if i == 1
                pushfirst!(b.dig, -1)
            else
                b.dig[i - 1] -= 1
            end
        end
    end
    if (i = findfirst(x -> x != 0, b.dig)) != nothing
        if i > 1
            b.dig = b.dig[i:end]
        end
    else
        b.dig = [0]
    end
    if b.p > 0 && (i = findlast(x -> x != 0, b.dig)) != nothing
        removable = min(b.p, length(b.dig) - i)
        b.dig = b.dig[1:end-removable]
        b.p -= removable
    end
    return b
end

# The following should work with any base number where dig, p are a similar array and Int
# and the proper constructors, canon, and conversion routines are defined     # 6

Base.print(io::IO, b::BalancedBaseDigitArray) = print(io, String(b))

function +(b1::T, b2::T) where T <: BalancedBaseDigitArray                 # 4
    if all(x -> x == 0, b1.dig)
        return deepcopy(b2)
    elseif all(x -> x == 0, b2.dig)
        return deepcopy(b1)
    end
    ldigits1 = length(b1.dig) - b1.p
    arr = b1.dig[1:ldigits1]
    ldigits2 = length(b2.dig) - b2.p
    arr2 = b2.dig[1:ldigits2]
    if (i = ldigits1 - ldigits2) > 0
        arr2 = [zeros(Int8, i); arr2]
    elseif i < 0
        arr = [zeros(Int8, -i); arr]
    end
    if (i = b1.p - b2.p) > 0
        arr = [arr; b1.dig[ldigits1+1:end]]
        arr2 = [arr2; b2.dig[ldigits2+1:end]; zeros(Int8, i)]
    elseif i < 0
        arr = [arr; b1.dig[ldigits1+1:end]; zeros(Int8, -i)]
        arr2 = [arr2; b2.dig[ldigits2+1:end]]
    else
        arr = [arr; b1.dig[ldigits1+1:end]]
        arr2 = [arr2; b2.dig[ldigits2+1:end]]
    end
    arr .+= arr2
    return canonicalize!(T(arr, max(b1.p, b2.p)))
end

-(b1::T) where T <: BalancedBaseDigitArray = T(b1.dig .* -1, b1.p)            # 4
-(b1::T, b2::T) where T <: BalancedBaseDigitArray = +(b1, -b2)                # 4

function *(b1::T, b2::T) where T <: BalancedBaseDigitArray                    # 4
    len = length(b2.dig)
    bsum = T()
    for i in len:-1:1
        bsum += T([b1.dig .* b2.dig[i]; zeros(Int8, len - i)], 0)
    end
    bsum.p = b1.p + b2.p
    return canonicalize!(bsum)
end

function code_reuse_task(T::Type)
    a = T("+-0++0+.+-0++0+")
    b = T(-436.436)
    c = T("+-++-.+-++-")
    println(" a = ", a, " = ", @sprintf("%.5f", BigFloat(a)))
    println(" b = ", b, " = ", @sprintf("%.5f", BigFloat(b)))
    println(" c = ", c, " = ", @sprintf("%.5f", BigFloat(c)))
    println("\na * (b - c) = ", String(a * (b - c)), "\n = ", @sprintf("%.5f", BigFloat(a * (b - c))))

    println("\n           Multiplication 27 X 12")
    println(" x|+ (1)  |+- (2) |+0 (3) |++ (4) |+-- (5)|+-0 (6)|+-+ (7)|+0- (8)|+e+-(9)|+0+(10)|++-(11)|++0(12)|")
    for i in 1:27
        print(lpad(i, 2), "|")
        for j in 1:12
            print(lpad(String(T(i * j)), 7), "|")
        end
        print("\n")
    end
end

code_reuse_task(BalancedTernary)
