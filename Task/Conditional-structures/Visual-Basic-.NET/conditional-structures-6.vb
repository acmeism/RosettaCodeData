Imports Microsoft.VisualBasic

...

Function IIf2(Of T)(ByVal condition As Boolean, ByVal truepart As T, ByVal falsepart As T) As T
  If condition Then Return truepart Else Return falsepart
End Function

...

Dim result As String = IIf2("pants" = "glasses", "passed", "failed") ' type is inferred
