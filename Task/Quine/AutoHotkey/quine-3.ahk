quote := Chr(34)
sep := Chr(36)
nl := Chr(13) . Chr(10)
script := "quote := Chr(34)$sep := Chr(36)$nl := Chr(13) . Chr(10)$script := #$s := script$StringReplace script, script, %sep%, %nl%, All$StringReplace script, script, #, %quote%%s%%quote%$FileAppend %script%, %A_ScriptDir%\Q.txt"
s := script
StringReplace script, script, %sep%, %nl%, All
StringReplace script, script, #, %quote%%s%%quote%
FileAppend %script%, %A_ScriptDir%\Q.txt
