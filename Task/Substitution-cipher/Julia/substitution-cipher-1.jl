module SubstitutionCiphers

using Compat

const key = "]kYV}(!7P\$n5_0i R:?jOWtF/=-pe'AD&@r6%ZXs\"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\\C1yxJ"

function encode(s::AbstractString)
    buf = IOBuffer()
    for c in s
        print(buf, key[Int(c) - 31])
    end
    return String(take!(buf))
end

function decode(s::AbstractString)
    buf = IOBuffer()
    for c in s
        print(buf, Char(findfirst(==(c), key) + 31))
    end
    return String(take!(buf))
end

end  # module SubstitutionCiphers
