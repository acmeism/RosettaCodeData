const digits = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
function encodebase58(b::Vector{<:Integer})
    out = Vector{Char}(34)
    for j in endof(out):-1:1
        local c::Int = 0
        for i in eachindex(b)
            c = c * 256 + b[i]
            b[i] = c ÷ 58
            c %= 58
        end
        out[j] = digits[c + 1]
    end
    local i = 1
    while i < endof(out) && out[i] == '1'
        i += 1
    end
    return join(out[i:end])
end

const COINVER = 0x00
function pubpoint2address(x::Vector{UInt8}, y::Vector{UInt8})
    c = vcat(0x04, x, y)
    c = vcat(COINVER, digest("ripemd160", sha256(c)))
    d = sha256(sha256(c))
    return encodebase58(vcat(c, d[1:4]))
end
pubpoint2address(x::AbstractString, y::AbstractString) =
    pubpoint2address(hex2bytes(x), hex2bytes(y))
