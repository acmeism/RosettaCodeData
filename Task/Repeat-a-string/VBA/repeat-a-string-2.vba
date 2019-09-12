Public Function RepeatString(stText As String, iQty As Integer) As String
  RepeatString = Replace(String(iQty, "x"), "x", stText)
End Function
