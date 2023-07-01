Option Explicit

Sub Main()
Const VECSIZE As Long = 3350
Const BUFSIZE As Long = 201
Dim buffer(1 To BUFSIZE) As Long
Dim vect(1 To VECSIZE) As Long
Dim more As Long, karray As Long, num As Long, k As Long, l As Long, n As Long

  For n = 1 To VECSIZE
    vect(n) = 2
  Next n
  For n = 1 To BUFSIZE
    karray = 0
    For l = VECSIZE To 1 Step -1
      num = 100000 * vect(l) + karray * l
      karray = num \ (2 * l - 1)
      vect(l) = num - karray * (2 * l - 1)
    Next l
    k = karray \ 100000
    buffer(n) = more + k
    more = karray - k * 100000
  Next n
  Debug.Print CStr(buffer(1));
  Debug.Print "."
  l = 0
  For n = 2 To BUFSIZE
    Debug.Print Format$(buffer(n), "00000");
    l = l + 1
    If l = 10 Then
      l = 0
      Debug.Print 'line feed
    End If
  Next n
End Sub
