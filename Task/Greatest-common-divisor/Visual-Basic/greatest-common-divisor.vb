Function GCD(ByVal a As Long, ByVal b As Long) As Long
Dim h As Long

    If a Then
        If b Then
            Do
                h = a Mod b
                a = b
                b = h
            Loop While b
        End If
        GCD = Abs(a)
    Else
        GCD = Abs(b)
    End If

End Function

Sub Main()
' testing the above function

  Debug.Assert GCD(12, 18) = 6
  Debug.Assert GCD(1280, 240) = 80
  Debug.Assert GCD(240, 1280) = 80
  Debug.Assert GCD(-240, 1280) = 80
  Debug.Assert GCD(240, -1280) = 80
  Debug.Assert GCD(0, 0) = 0
  Debug.Assert GCD(0, 1) = 1
  Debug.Assert GCD(1, 0) = 1
  Debug.Assert GCD(3475689, 23566319) = 7
  Debug.Assert GCD(123456789, 234736437) = 3
  Debug.Assert GCD(3780, 3528) = 252

End Sub
