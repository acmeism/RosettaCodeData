function manacher(str)
    s =  "^" * join(split(str, ""), "#") * "\$"
    len = length(s)
    pals = fill(0, len)
    center, right = 1, 1
    for i in 2:len-1
        pals[i] = right > i && right - i > 0 && pals[2 * center - i] > 0
        while s[i + pals[i] + 1] == s[i - pals[i] - 1]
            pals[i] += 1
        end
        if i + pals[i] > right
            center, right = i, i + pals[i]
        end
    end
    maxlen, centerindex = findmax(pals)
    start = isodd(maxlen) ? (centerindex-maxlen) ÷ 2 + 1 : (centerindex-maxlen) ÷ 2
    return str[start:(centerindex+maxlen)÷2]
end

for teststring in ["babaccd", "rotator", "reverse", "forever", "several", "palindrome", "abaracadabra"]
    pal = manacher(teststring)
    println(length(pal) < 2 ? "No palindromes of 2 or more letters found in \"$teststring.\"" :
        "The longest palindromic substring of $teststring is: \"$pal\"")
end
