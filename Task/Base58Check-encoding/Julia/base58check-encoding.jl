const alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

function encodebase58(hsh::AbstractString, base::Integer=16)
    x = if base == 16 && hsh[1:2] == "0x" parse(BigInt, hsh[3:end], 16)
        else parse(BigInt, hsh, base) end
    sb = IOBuffer()
    while x > 0
        x, r = divrem(x, 58)
        print(sb, alpha[r + 1])
    end
    return String(sb) |> reverse
end

s = "25420294593250030202636073700053352635053786165627414518"
println("# $s\n -> ", encodebase58(s, 10))
for s in ["0x61", "0x626262", "0x636363", "0x73696d706c792061206c6f6e6720737472696e67",
          "0x516b6fcd0f", "0xbf4f89001e670274dd", "0x572e4794", "0xecac89cad93923c02321",
          "0x10c8511e"]
    println("# $s\n -> ", encodebase58(s))
end
