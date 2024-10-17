let s = "The quick brown fox jumps over the lazy dog, who barks VERY loudly!"
    enc = SubstitutionCiphers.encode(s)
    dec = SubstitutionCiphers.decode(enc)
    println("Original: ", s, "\n -> Encoded: ", enc, "\n -> Decoded: ", dec)
end
