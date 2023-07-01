FileRead, fileContents, Traceback.txt
keyWord      := "SystemError"    ; or regex like "SystemE\w+"
beginWith    := "Traceback (most recent call last):"
for i, paragraph in StrSplit(StrReplace(fileContents, "`r"), "`n`n")
    result   .= RegExMatch(paragraph, keyWord) ? SubStr(paragraph, InStr(paragraph, beginWith, 1)) "`n----------------`n" : ""
MsgBox % result
