Dim result As String, a As String = "pants", b As String = "glasses"

Select Case a
  Case b
    result = "match"
  Case a : result = "duh"
  Case Else
    result = "impossible"
End Select
