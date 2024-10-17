import Base.*, Base.+, Base.-, Base./, Base.show, Base.!=, Base.==, Base.<=, Base.<, Base.>, Base.>=, Base.divrem

const z0 = "0"
const z1 = "1"
const flipordered = (z1 < z0)

mutable struct Z s::String end
Z() = Z(z0)
Z(z::Z) = Z(z.s)

pairlen(x::Z, y::Z) = max(length(x.s), length(y.s))
tolen(x::Z, n::Int) = (s = x.s; while length(s) < n s = z0 * s end; s)

<(x::Z, y::Z) = (l = pairlen(x, y); flipordered ? tolen(x, l) > tolen(y, l) : tolen(x, l) < tolen(y, l))
>(x::Z, y::Z) = (l = pairlen(x, y); flipordered ? tolen(x, l) < tolen(y, l) : tolen(x, l) > tolen(y, l))
==(x::Z, y::Z) = (l = pairlen(x, y); tolen(x, l) == tolen(y, l))
<=(x::Z, y::Z) = (l = pairlen(x, y); flipordered ? tolen(x, l) >= tolen(y, l) : tolen(x, l) <= tolen(y, l))
>=(x::Z, y::Z) = (l = pairlen(x, y); flipordered ? tolen(x, l) <= tolen(y, l) : tolen(x, l) >= tolen(y, l))
!=(x::Z, y::Z) = (l = pairlen(x, y); tolen(x, l) != tolen(y, l))

function tocanonical(z::Z)
    while occursin(z0 * z1 * z1, z.s)
        z.s = replace(z.s, z0 * z1 * z1 => z1 * z0 * z0)
    end
    len = length(z.s)
    if len > 1 && z.s[1:2] == z1 * z1
        z.s = z1 * z0 * z0 * ((len > 2) ? z.s[3:end] : "")
    end
    while (len = length(z.s)) > 1 && string(z.s[1]) == z0
        if len == 2
            if z.s == z0 * z0
                z.s = z0
            elseif z.s == z0 * z1
                z.s = z1
            end
        else
            z.s = z.s[2:end]
        end
    end
    z
end

function inc(z)
    if z.s[end] == z0[1]
        z.s = z.s[1:end-1] * z1[1]
    elseif z.s[end] == z1[1]
        if length(z.s) > 1
            if z.s[end-1:end] == z0 * z1
                z.s = z.s[1:end-2] * z1 * z0
            end
        else
            z.s = z1 * z0
        end
    end
    tocanonical(z)
end

function dec(z)
    if z.s[end] == z1[1]
        z.s = z.s[1:end-1] * z0
    else
        if (m = match(Regex(z1 * z0 * '+' * '$'), z.s)) != nothing
            len = length(m.match)
            if iseven(len)
                z.s = z.s[1:end-len] * (z0 * z1) ^ div(len, 2)
            else
                z.s = z.s[1:end-len] * (z0 * z1) ^ div(len, 2) * z0
            end
        end
    end
    tocanonical(z)
    z
end

function +(x::Z, y::Z)
    a = Z(x.s)
    b = Z(y.s)
    while b.s != z0
        inc(a)
        dec(b)
    end
    a
end

function -(x::Z, y::Z)
    a = Z(x.s)
    b = Z(y.s)
    while b.s != z0
        dec(a)
        dec(b)
    end
    a
end

function *(x::Z, y::Z)
    if (x.s == z0) || (y.s == z0)
        return Z(z0)
    elseif x.s == z1
        return Z(y.s)
    elseif y.s == z1
        return Z(x.s)
    end
    a = Z(x.s)
    b = Z(z1)
    while b != y
        c = Z(z0)
        while c != x
            inc(a)
            inc(c)
        end
        inc(b)
    end
    a
end

function divrem(x::Z, y::Z)
    if y.s == z0
        throw("Zeckendorf division by 0")
    elseif (y.s == z1) || (x.s == z0)
        return Z(x.s)
    end
    a = Z(x.s)
    b = Z(y.s)
    c = Z(z0)
    while a > b
        a = a - b
        inc(c)
    end
    tocanonical(c), tocanonical(a)
end

function /(x::Z, y::Z)
    a, _ = divrem(x, y)
    a
end

show(io::IO, z::Z) = show(io, parse(BigInt, tocanonical(z).s))

function zeckendorftest()
    a = Z("10")
    b = Z("1001")
    c = Z("1000")
    d = Z("10101")

    println("Addition:")
    x = a
    println(x += a)
    println(x += a)
    println(x += b)
    println(x += c)
    println(x += d)

    println("\nSubtraction:")
    x = Z("1000")
    println(x - Z("101"))
    x = Z("10101010")
    println(x - Z("1010101"))

    println("\nMultiplication:")
    x = Z("1001")
    y = Z("101")
    println(x * y)
    println(Z("101010") * y)

    println("\nDivision:")
    x = Z("1000101")
    y = Z("101")
    println(x / y)
    println(divrem(x, y))
end

zeckendorftest()
