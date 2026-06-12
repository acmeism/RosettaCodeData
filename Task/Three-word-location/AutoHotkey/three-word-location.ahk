URLDownloadToFile, http://www-personal.umich.edu/~jlawler/wordlist, % A_Temp "\wordlist.txt"
FileRead, wordList, % A_Temp "\wordlist.txt"

LL := [28.3852, -81.5638]
num := LL2num(LL)
words := LL2words(wordList, LL)
LL2 := words2LL(wordList, words)

MsgBox, 262144, , % result := "
(
LL = " LL.1 ", " LL.2 "
LL2num = " num.1 ", " num.2 ", " num.3 "
LL2words = " words.1 ", " words.2 ", " words.3 "
words2LL = " LL2.1 ", " LL2.2 "
)"
return
;-----------------------------------------------
LL2words(wordList, LL){    ; Latitude/Longitude to 3 words
    num := LL2num(LL)
    wli := wordList(wordList).1
    return [wli[num.1], wli[num.2], wli[num.3]]
}
;-----------------------------------------------
words2LL(wordList, w){    ; 3 words to Latitude/Longitude
    iow := wordList(wordList).2
    LL := num2LL([iow[w.1], iow[w.2], iow[w.3]])
    return [ll.1, ll.2]
}
;-----------------------------------------------
wordList(wordList){        ; word list to two arrays
    wli:=[], iow:=[]    ; word list index, index of word
    for i, word in StrSplit(wordList, "`n", "`r")
        if (word ~= "^[a-z]+$") && (StrLen(word) <= 8) && (StrLen(word) > 3)
            wli.Push(word), iow[word] := wli.MaxIndex()
    return [wli, iow]
}
;-----------------------------------------------
LL2num(LL){                ; Latitude/Longitude to 3 numbers
    ilat := LL.1*10000 + 900000
    ilon := LL.2*10000 + 1800000
    latlon := (ilat << 22) + ilon
    return [(latlon >> 28) & 0x7fff, (latlon >> 14) & 0x3fff, latlon & 0x3fff]
}
;-----------------------------------------------
num2LL(w){                ; 3 numbers to Latitude/Longitude
    latlon := (w.1 << 28) | (w.2 << 14) | w.3
    ilat := latlon >> 22
    ilon := latlon & 0x3fffff
    return [(ilat-900000)/10000, (ilon-1800000)/10000]
}
;-----------------------------------------------
