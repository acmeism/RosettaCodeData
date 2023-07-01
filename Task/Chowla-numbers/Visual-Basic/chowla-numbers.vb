Option Explicit

Private Declare Function AllocConsole Lib "kernel32.dll" () As Long
Private Declare Function FreeConsole Lib "kernel32.dll" () As Long
Dim mStdOut As Scripting.TextStream

Function chowla(ByVal n As Long) As Long
Dim j As Long, i As Long
  i = 2
  Do While i * i <= n
    j = n \ i
    If n Mod i = 0 Then
    chowla = chowla + i
      If i <> j Then
      chowla = chowla + j
      End If
    End If
    i = i + 1
  Loop
End Function

Function sieve(ByVal limit As Long) As Boolean()
Dim c() As Boolean
Dim i As Long
Dim j As Long
  i = 3
  ReDim c(limit - 1)
    Do While i * 3 < limit
      If Not c(i) Then
        If (chowla(i) = 0) Then
          j = 3 * i
          Do While j < limit
            c(j) = True
            j = j + 2 * i
          Loop
        End If
    End If
    i = i + 2
    Loop
  sieve = c()
End Function

Sub Display(ByVal s As String)
  Debug.Print s
  mStdOut.Write s & vbNewLine
End Sub

Sub Main()
Dim i As Long
Dim count As Long
Dim limit As Long
Dim power As Long
Dim c() As Boolean
Dim p As Long
Dim k As Long
Dim kk As Long
Dim s As String * 30
Dim mFSO As Scripting.FileSystemObject
Dim mStdIn As Scripting.TextStream

  AllocConsole
  Set mFSO = New Scripting.FileSystemObject
  Set mStdIn = mFSO.GetStandardStream(StdIn)
  Set mStdOut = mFSO.GetStandardStream(StdOut)

  For i = 1 To 37
    Display "chowla(" & i & ")=" & chowla(i)
  Next i

  count = 1
  limit = 10000000
  power = 100
  c = sieve(limit)

  For i = 3 To limit - 1 Step 2
    If Not c(i) Then
      count = count + 1
    End If
    If i = power - 1 Then
      RSet s = FormatNumber(power, 0, vbUseDefault, vbUseDefault, True)
      Display "Count of primes up to " & s & " = " & FormatNumber(count, 0, vbUseDefault, vbUseDefault, True)
      power = power * 10
    End If
  Next i

  count = 0: limit = 35000000
  k = 2:     kk = 3

  Do
    p = k * kk
    If p > limit Then
      Exit Do
    End If

    If chowla(p) = p - 1 Then
      RSet s = FormatNumber(p, 0, vbUseDefault, vbUseDefault, True)
      Display s & " is a number that is perfect"
      count = count + 1
    End If
    k = kk + 1
    kk = kk + k
  Loop

  Display "There are " & CStr(count) & " perfect numbers <= 35.000.000"

  mStdOut.Write "press enter to quit program."
  mStdIn.Read 1

  FreeConsole

End Sub
