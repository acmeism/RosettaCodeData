data := [""
    , """If I were two-faced, would I be wearing this one?"" --- Abraham Lincoln "
    , "..1111111111111111111111111111111111111111111111111111111111111117777888"
    , "I never give 'em hell, I just tell the truth, and they think it's hell. "]
char := ["","-","7","."]
for i, str in data
    MsgBox % squeezable_string(str, char[i])

str := "                                                    --- Harry S Truman  "
for i, char in [" ","-","r"]
    MsgBox % squeezable_string(str, char)
return
