function rsaencode(clearmsg::AbstractString, nmod::Integer, expub::Integer)
    bytes = parse(BigInt, "0x" * bytes2hex(collect(UInt8, clearmsg)))
    return powermod(bytes, expub, nmod)
end

function rsadecode(cryptmsg::Integer, nmod::Integer, dsecr::Integer)
    decoded = powermod(encoded, dsecr, nmod)
    return join(Char.(hex2bytes(hex(decoded))))
end

msg = "Rosetta Code."
nmod = big"9516311845790656153499716760847001433441357"
expub = 65537
dsecr = big"5617843187844953170308463622230283376298685"

encoded = rsaencode(msg, nmod, expub)
decoded = rsadecode(encoded, nmod, dsecr)
println("\n# $msg\n -> ENCODED: $encoded\n -> DECODED: $decoded")
