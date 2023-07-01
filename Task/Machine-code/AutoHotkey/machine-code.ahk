MCode(Var, "8B44240403442408C3")
MsgBox, % DllCall(&Var, "Char",7, "Char",12)
Var := ""
return

; http://www.autohotkey.com/board/topic/19483-machine-code-functions-bit-wizardry/
MCode(ByRef code, hex) { ; allocate memory and write Machine Code there
   VarSetCapacity(code, StrLen(hex) // 2)
   Loop % StrLen(hex) // 2
      NumPut("0x" . SubStr(hex, 2 * A_Index - 1, 2), code, A_Index - 1, "Char")
}
