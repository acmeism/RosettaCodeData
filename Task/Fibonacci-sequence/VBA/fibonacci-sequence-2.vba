Public Function RFib(Term As Integer) As Long
  If Term < 2 Then RFib = Term Else RFib = RFib(Term - 1) + RFib(Term - 2)
End Function
