Public Function checkBrackets(s As String) As Boolean
'function checks strings for balanced brackets
Dim Depth As Integer
Dim ch As String * 1

Depth = 0
For i = 1 To Len(s)
  ch = Mid$(s, i, 1)
  If ch = "[" Then Depth = Depth + 1
  If ch = "]" Then
    If Depth = 0 Then 'not balanced
      checkBrackets = False
      Exit Function
    Else
      Depth = Depth - 1
    End If
  End If
Next
checkBrackets = (Depth = 0)
End Function

Public Function GenerateBrackets(N As Integer) As String
'generate a string with N opening and N closing brackets in random order
Dim s As String
Dim N2 As Integer, j As Integer
Dim Brackets() As String * 1
Dim temp As String * 1

'catch trivial value
If N <= 0 Then
  GenerateBrackets = ""
  Exit Function
End If

N2 = N + N
ReDim Brackets(1 To N2)
For i = 1 To N2 Step 2
 Brackets(i) = "["
 Brackets(i + 1) = "]"
Next i
'shuffle.
For i = 1 To N2
  j = 1 + Int(Rnd() * N2)
  'swap brackets i and j
  temp = Brackets(i)
  Brackets(i) = Brackets(j)
  Brackets(j) = temp
Next i
'generate string
s = ""
For i = 1 To N2
  s = s & Brackets(i)
Next i
GenerateBrackets = s
End Function

Public Sub BracketsTest()
Dim s As String
Dim i As Integer

For i = 0 To 10
 s = GenerateBrackets(i)
 Debug.Print """" & s & """: ";
 If checkBrackets(s) Then Debug.Print " OK" Else Debug.Print " Not OK"
Next
End Sub
