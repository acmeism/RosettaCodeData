Imports Tu = System.Tuple(Of Integer, Integer)

Module Module1

  Sub Main()
    Dim w As New List(Of Tu), sum, x As Integer,
        lst() As Integer = { 2, 3, 5, 7 }
    For Each x In lst : w.Add(New Tu(x, x)) : Next
    While w.Count > 0 : With w(0) : For Each j As Integer In lst
        sum = .Item2 + j
        If sum = 13 Then Console.Write("{0}{1} ", .Item1, j)
        If sum < 12 Then w.Add(New Tu(.Item1 * 10 + j, sum))
      Next : End With : w.RemoveAt(0) : End While
  End Sub

End Module
