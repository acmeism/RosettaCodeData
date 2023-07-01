Function CountStringInString(stLookIn As String, stLookFor As String)
    CountStringInString = UBound(Split(stLookIn, stLookFor))
End Function
