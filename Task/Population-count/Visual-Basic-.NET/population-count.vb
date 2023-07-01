Imports System.Console, System.Diagnostics

Module Module1

  Dim i As Integer, eo As Boolean
 
  Function PopCnt(n As Long) As Integer
    Return Convert.ToString(n, 2).ToCharArray().Where(Function(x) x = "1").Count()
  End Function
 
  Sub Aline(a As List(Of Integer), title As String)
    WriteLine("{0,-8}{1}", title, String.Join(" ", a.Take(30)))
  End Sub

  Sub Main(ByVal args As String())
    WriteLine("Population Counts:") : Dim t, e, o As New List(Of Integer)
    For c As Integer = 0 To 99
      If (PopCnt(c) And 1) = 0 Then e.Add(c) Else o.Add(c)
      If c < 30 Then t.Add(PopCnt(CLng(Math.Pow(3, c))))
    Next
    Aline(t, "3^n :") : Aline(e, "Evil:") : Aline(o, "Odious:")
    ' Extra:
    WriteLine(vbLf & "Pattern:{0}", Pattern(e, o))
    If Debugger.IsAttached Then ReadKey()
  End Sub

  ' support routines for pattern output
  Function Same(a As List(Of Integer)) As Boolean
    Return a(i) + 1 = a(i + 1)
  End Function

  Function Odd(a As List (Of Integer), b As List (Of Integer)) As Boolean
    eo = Not eo : If a(i) = b(i) + 1 Then i -= 1 : Return True
    Return False
  End Function

  Function SoO(a As List (Of Integer), b As List (Of Integer), c As String) As String
    Return If(Same(a), c(0), If(Odd(b, a), c(1), c(2)))
  End Function

  Function Either(a As List(Of Integer), b As List(Of Integer)) As String
    Return If(eo, SoO(a, b, "⌢↓↘"), SoO(b, a, "⌣↑↗"))
  End Function

  Function Pattern(a As List(Of Integer), b As List(Of Integer)) As String
    eo = a.Contains(0) : Dim res As New Text.StringBuilder
    For i = 0 To a.Count - 2 : res.Append(Either(a, b)) : Next
    Return res.ToString()
  End Function

End Module
