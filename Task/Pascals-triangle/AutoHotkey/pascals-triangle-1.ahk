n := 8, p0 := "1"        ; 1+n rows of Pascal's triangle
Loop %n% {
   p := "p" A_Index, %p% := v := 1, q := "p" A_Index-1
   Loop Parse, %q%, %A_Space%
      If (A_Index > 1)
         %p% .= " " v+A_LoopField, v := A_LoopField
   %p% .= " 1"
}
                         ; Triangular Formatted output
VarSetCapacity(tabs,n,Asc("`t"))
t .= tabs "`t1"
Loop %n% {
   t .= "`n" SubStr(tabs,A_Index)
   Loop Parse, p%A_Index%, %A_Space%
      t .= A_LoopField "`t`t"
}
Gui Add, Text,, %t%      ; Show result in a GUI
Gui Show
Return

GuiClose:
  ExitApp
