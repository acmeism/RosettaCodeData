Public Function countbottles(n As Integer, liquid As String) As String
  countbottles = IIf(n > 1, Format$(n), IIf(n = 0, "no more", "one")) & " bottle" & IIf(n = 1, "", "s") & " of " & liquid
End Function

Public Sub drink(fullbottles As Integer, Optional liquid As String = "beer")
Static emptybottles As Integer

  Debug.Print countbottles(fullbottles, liquid) & " on the wall"
  Debug.Print countbottles(fullbottles, liquid)

  If fullbottles > 0 Then
    Debug.Print "take " & IIf(fullbottles > 1, "one", "it") & " down, pass it around"
    Debug.Print countbottles(fullbottles - 1, liquid) & " on the wall"
    Debug.Print
    emptybottles = emptybottles + 1
    drink fullbottles - 1, liquid
  Else
    Debug.Print "go to the store and buy some more"
    Debug.Print countbottles(emptybottles, liquid) & " on the wall"
  End If

End Sub
