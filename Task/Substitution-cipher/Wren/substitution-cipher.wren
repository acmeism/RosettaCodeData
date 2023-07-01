var key = "]kYV}(!7P$n5_0i R:?jOWtF/=-pe'AD&@r6\%ZXs\"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\\C1yxJ"

var encode = Fn.new { |s|
    var res = ""
    for (c in s) res = res + key[c.bytes[0] - 32]
    return res
}

var decode = Fn.new { |s|
    var res = ""
    for (c in s) res = res + String.fromByte(key.indexOf(c) + 32)
    return res
}

var s = "The quick brown fox jumps over the lazy dog, who barks VERY loudly!"
var enc = encode.call(s)
System.print("Encoded:  %(enc)")
System.print("Decoded:  %(decode.call(enc))")
