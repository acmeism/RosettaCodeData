Public Sub Permute(n As Integer, Optional printem As Boolean = True)
'generate, count and print (if printem is not false) all permutations of first n integers

Dim P() As Integer
Dim count As Long
dim Last as boolean
Dim t, i, j, k As Integer

If n <= 1 Then
  Debug.Print "give a number greater than 1!"
  Exit Sub
End If

'initialize
ReDim P(n)
For i = 1 To n: P(i) = i: Next
count = 0
Last = False

Do While Not Last
 'print?
 If printem Then
   For t = 1 To n: Debug.Print P(t);: Next
   Debug.Print
 End If
 count = count + 1

 Last = True
 i = n - 1
 Do While i > 0
   If P(i) < P(i + 1) Then
     Last = False
      Exit Do
   End If
   i = i - 1
 Loop

 If Not Last Then
   j = i + 1
   k = n
   While j < k
     ' swap p(j) and p(k)
     t = P(j)
     P(j) = P(k)
     P(k) = t
     j = j + 1
     k = k - 1
   Wend
   j = n
   While P(j) > P(i)
     j = j - 1
   Wend
   j = j + 1
   'swap p(i) and p(j)
   t = P(i)
   P(i) = P(j)
   P(j) = t
 End If 'not last

Loop 'while not last

Debug.Print "Number of permutations: "; count

End Sub
