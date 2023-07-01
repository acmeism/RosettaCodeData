function playfair(key, txt, isencode=true, from = "J", to = "")
    to = (to == "" && from == "J") ? "I" : to

    function canonical(s, dup_toX=true)
        s = replace(replace(uppercase(s), from => to), r"[^A-Z]" => "")
        a, dupcount = [c for c in s], 0
        for i in 1:2:length(a)-1
            if s[i] == s[i + 1]
                dup_toX && splice!(a, i+1+dupcount:i+dupcount, 'X')
                dupcount += 1
            end
        end
        s = String(a)
        return isodd(length(s)) ? s * "X" : s
    end

    # Translate key into an encoding 5x5 translation matrix.
    keyletters = unique([c for c in canonical(key * "ABCDEFGHIJKLMNOPQRSTUVWXYZ", false)])
    m = Char.((reshape(UInt8.(keyletters[1:25]), 5, 5)'))

    # encod is a dictionary of letter pairs for encoding.
    encod = Dict()

    # Map pairs in same row or same column of matrix m.
    for i in 1:5, j in 1:5, k in 1:5
        if j != k
            encod[m[i, j] * m[i, k]] = m[i, mod1(j + 1, 5)] * m[i, mod1(k + 1, 5)]
        end
        if i != k
            encod[m[i, j] * m[k, j]] = m[mod1(i + 1, 5), j] * m[mod1(k + 1, 5), j]
        end
        # Map pairs not on same row or same column.
        for l in 1:5
            if i != k && j != l
                encod[m[i, j] * m[k, l]] = m[i, l] * m[k, j]
            end
        end
    end

    # Get array of pairs of letters from text.
    canontxt = canonical(txt)
    letterpairs = [canontxt[i:i+1] for i in 1:2:length(canontxt)-1]

    if isencode
        # Encode text
        return join([encod[pair] for pair in letterpairs], " ")
    else
        # Decode text
        decod = Dict((v, k) for (k, v) in encod)
        return join([decod[pair] for pair in letterpairs], " ")
    end
end

orig = "Hide the gold in...the TREESTUMP!!!"
println("Original: ", orig)

encoded = playfair("Playfair example", orig)
println("Encoded: ", encoded)

println("Decoded: ", playfair("Playfair example", encoded, false))
