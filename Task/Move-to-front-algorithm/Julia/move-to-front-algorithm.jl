function encodeMTF(str::AbstractString, symtable::Vector{Char}=collect('a':'z'))
    function encode(ch::Char)
        r = findfirst(symtable, ch)
        deleteat!(symtable, r)
        prepend!(symtable, ch)
        return r
    end
    collect(encode(ch) for ch in str)
end

function decodeMTF(arr::Vector{Int}, symtable::Vector{Char}=collect('a':'z'))
    function decode(i::Int)
        r = symtable[i]
        deleteat!(symtable, i)
        prepend!(symtable, r)
        return r
    end
    join(decode(i) for i in arr)
end

testset = ["broood", "bananaaa", "hiphophiphop"]
encoded = encodeMTF.(testset)
decoded = decodeMTF.(encoded)
for (str, enc, dec) in zip(testset, encoded, decoded)
    println("Test string: $str\n -> Encoded: $enc\n -> Decoded: $dec")
end

using Base.Test
@testset "Decoded string equal to original" begin
    for (str, dec) in zip(testset, decoded)
        @test str == dec
    end
end
