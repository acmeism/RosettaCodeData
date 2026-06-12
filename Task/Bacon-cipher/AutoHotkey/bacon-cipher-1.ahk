Bacon_Cipher(message, plaintext:=""){
    codes := {"a":"AAAAA", "b":"AAAAB", "c":"AAABA", "d":"AAABB", "e":"AABAA"
            , "f":"AABAB", "g":"AABBA", "h":"AABBB", "i":"ABAAA", "j":"ABAAB"
            , "k":"ABABA", "l":"ABABB", "m":"ABBAA", "n":"ABBAB", "o":"ABBBA"
            , "p":"ABBBB", "q":"BAAAA", "r":"BAAAB", "s":"BAABA", "t":"BAABB"
            , "u":"BABAA", "v":"BABAB", "w":"BABBA", "x":"BABBB", "y":"BBAAA"
            , "z":"BBAAB", " ":"BBBAA"}

    if (plaintext<>"") {
        for i, letter in StrSplit(plaintext)
            code .= codes[letter]

        x := StrSplit(code)
        for i, letter in StrSplit(message)
            if (Asc(letter) >= 97 and Asc(letter) <= 122)
                if !(l := x.RemoveAt(1))
                    break
                else if (l = "A")
                    cipher .= letter
                else
                    cipher .= Chr(Asc(letter) - 32)
            else
                cipher .= letter
        return cipher
    } else {
        Keys := []
        for l, c in codes
            Keys[c] := l

        for i, letter in StrSplit(message)
            if (Asc(letter) >= 97 and Asc(letter) <= 122)
                pattern .= "A"
            else if (Asc(letter) >= 65 and Asc(letter) <= 90)
                pattern .= "B"

        while StrLen(pattern)
            str .= Keys[SubStr(pattern, 1, 5)]
            , pattern := SubStr(pattern, 6)
        return str
    }
}
