(* Only non-accented English letters are altered here. *)

on caesarDecipher(txt, |key|)
    return caesarEncipher(txt, -|key|)
end caesarDecipher

on caesarEncipher(txt, |key|)
    set codePoints to id of txt
    set keyPlus25 to |key| mod 26 + 25
    repeat with thisCode in codePoints
        tell thisCode mod 32
            if ((it < 27) and (it > 0) and (thisCode div 64 is 1)) then ¬
                set thisCode's contents to thisCode - it + (it + keyPlus25) mod 26 + 1
        end tell
    end repeat

    return string id codePoints
end caesarEncipher

-- Test code:
set txt to "ROMANES EUNT DOMUS!
The quick brown fox jumps over the lazy dog."
set |key| to 9

set enciphered to caesarEncipher(txt, |key|)
set deciphered to caesarDecipher(enciphered, |key|)
return "Text: '" & txt & ("'" & linefeed & "Key: " & |key| & linefeed & linefeed) & (enciphered & linefeed & deciphered)
