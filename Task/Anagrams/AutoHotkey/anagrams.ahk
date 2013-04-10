MsgBox % anagrams("able")

anagrams(word) {
   Static dict
   IfEqual dict,, FileRead dict, unixdict.txt ; file in the script directory
   w := sort(word)
   Loop Parse, dict, `n, `r
      If (w = sort(A_LoopField))
         t .= A_LoopField "`n"
   Return t
}

sort(word) {
   a := RegExReplace(word,".","$0`n")
   Sort a
   Return a
}
