Option Explicit

Sub Main()
   Debug.Print Quibbling("")
   Debug.Print Quibbling("ABC")
   Debug.Print Quibbling("ABC, DEF")
   Debug.Print Quibbling("ABC, DEF, G, H")
   Debug.Print Quibbling("ABC, DEF, G, H, IJKLM, NO, PQRSTUV")
End Sub

Private Function Quibbling(MyString As String) As String
Dim s As String, n As Integer
   s = "{" & MyString & "}": n = InStrRev(s, ",")
   If n > 0 Then s = Left(s, n - 1) & " and " & Right(s, Len(s) - (n + 1))
   Quibbling = s
End Function
