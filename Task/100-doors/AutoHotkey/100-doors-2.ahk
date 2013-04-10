increment := 3, square := 1
Loop, 100
    If (A_Index = square)
        outstring .= "`nDoor " A_Index " is open"
        ,square += increment, increment += 2
MsgBox,, Succesfull, % SubStr(outstring, 2)
