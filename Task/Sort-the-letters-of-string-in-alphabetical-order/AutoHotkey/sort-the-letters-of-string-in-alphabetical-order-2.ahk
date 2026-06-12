str1 := "The quick brown fox jumps over the lazy dog, apparently"
str2 := "Now is the time for all good men to come to the aid of their country."

MsgBox, 262144, , % result := str1 " ->`n" sortLetters(str1)
                . "`n`n" str2 " ->`n" sortLetters(str2, 0)
