Sequence isPangram := method(
    letters := " " repeated(26)
    ia := "a" at(0)
    foreach(ichar,
        if(ichar isLetter,
            letters atPut((ichar asLowercase) - ia, ichar)
        )
    )
    letters contains(" " at(0)) not     // true only if no " " in letters
)

"The quick brown fox jumps over the lazy dog." isPangram println    // --> true
"The quick brown fox jumped over the lazy dog." isPangram println   // --> false
"ABC.D.E.FGHI*J/KL-M+NO*PQ R\nSTUVWXYZ" isPangram println           // --> true
