' FB 1.05.0 Win64

Function isPangram(s As Const String) As Boolean
  Dim As Integer length = Len(s)
  If length < 26 Then Return False
  Dim p As String = LCase(s)
  For i As Integer = 97 To 122
    If Instr(p, Chr(i)) = 0 Then Return False
  Next
  Return True
End Function

Dim s(1 To 3) As String = _
{ _
 "The quick brown fox jumps over the lazy dog", _
 "abbdefghijklmnopqrstuVwxYz", _ '' no c!
 "How vexingly quick daft zebras jump!" _
}

For i As Integer = 1 To 3:
  Print "'"; s(i); "' is "; IIf(isPangram(s(i)), "a", "not a"); " pangram"
  Print
Next

Print
Print "Press nay key to quit"
Sleep
