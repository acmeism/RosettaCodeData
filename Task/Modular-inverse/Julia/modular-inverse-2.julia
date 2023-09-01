function modinv(a::T, b::T) where T <: Integer
    b0 = b
    x0, x1 = zero(T), one(T)
    while a > 1
        q = div(a, b)
        a, b = b, a % b
        x0, x1 = x1 - q * x0, x0
    end
    x1 < 0 ? x1 + b0 : x1
end
modinv(a::Integer, b::Integer) = modinv(promote(a,b)...)
