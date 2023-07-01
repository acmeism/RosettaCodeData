FileRead, wList, % A_Desktop "\unixdict.txt"
hexWords := Hex_words(wList)
Header := "Base 10`t`tWord`tRoot`n"
for dr, obj in hexWords
    for word, dec in obj
        result .= dec "`t" (StrLen(dec) < 8 ? "`t" : "") word "`t" dr "`n"

MsgBox, 262144, ,% result := Header . result . "`n4 distinct letter words:`n" . Header . filter(result, "abcdef", 4)
return
;-------------------------------------------
filter(result, letters, Count){
    for i, line in StrSplit(result, "`n", "`r") {
        counter := 0
        for j, letter in StrSplit(letters)
            StrReplace(line, letter, letter, cnt, 1), counter += cnt
        if (counter >= Count)
            filtered .= line "`n"
    }
    Sort, filtered, RN
    return filtered
}
;-------------------------------------------
Hex_words(wList){
    hexWords := []
    for i, w in StrSplit(wList, "`n", "`r") {
        if (StrLen(w) < 4 || w ~= "i)[^abcdef]")
            continue
        dec := hex2dec(w)
        dr := digital_root(dec)
        hexWords[dr, w] := dec
    }
    return hexWords
}
;-------------------------------------------
digital_root(n){
    loop {
        sum := 0, i := 1
        while (i <= StrLen(n))
            sum += SubStr(n, i++, 1)
        n := sum
    }
    until (sum < 10)
    return sum
}
