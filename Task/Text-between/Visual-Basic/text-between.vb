Public Function TextBetween(ByVal Text As String, ByVal StartDelim As String, ByVal EndDelim As String) As String
Dim indS As Long
Dim indE As Long

  If StartDelim = "start" Then
    indS = 1
  Else
    indS = InStr(1, Text, StartDelim)
    If indS Then
      indS = indS + Len(StartDelim)
    End If
  End If

  If indS Then
    If EndDelim = "end" Then
      indE = Len(Text) + 1
    Else
      indE = InStr(indS, Text, EndDelim)
      If indE = 0 Then
        indE = Len(Text) + 1
      End If
    End If
    indE = indE - indS
    If indE Then
      TextBetween = Mid$(Text, indS, indE)
    End If
  End If

End Function

' *********************

Sub Main()
' tests
Dim Text As String
Dim StartDelim As String
Dim EndDelim As String
Dim Expected As String

'Ex. 1
Text = "Hello Rosetta Code world"
StartDelim = "Hello "
EndDelim = " world"
Expected = "Rosetta Code"
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected

'Ex. 2
Text = "Hello Rosetta Code world"
StartDelim = "start"
EndDelim = " world"
Expected = "Hello Rosetta Code"
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected

'Ex. 3
Text = "Hello Rosetta Code world"
StartDelim = "Hello "
EndDelim = "end"
Expected = "Rosetta Code world"
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected

'Ex. 4
Expected = ChrW$(&H4F60) & ChrW$(&H597D) & ChrW$(&H55CE)
Text = "</div><div style=""chinese"">" & Expected & "</div>"
StartDelim = "<div style=""chinese"">"
EndDelim = "</div>"
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected

'Ex. 5
Text = "<text>Hello <span>Rosetta Code</span> world</text><table style=""myTable"">"
StartDelim = "<text>"
EndDelim = "<table>"
Expected = "Hello <span>Rosetta Code</span> world</text><table style=""myTable"">"
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected

'Ex. 6
Text = "<table style=""myTable""><tr><td>hello world</td></tr></table>"
StartDelim = "<table>"
EndDelim = "</table>"
Expected = ""
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected

'Ex. 7
Text = "The quick brown fox jumps over the lazy other fox"
StartDelim = "quick "
EndDelim = " fox"
Expected = "brown"
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected

'Ex. 8
Text = "One fish two fish red fish blue fish"
StartDelim = "fish "
EndDelim = " red"
Expected = "two fish"
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected

'Ex. 9
Text = "FooBarBazFooBuxQuux"
StartDelim = "Foo"
EndDelim = "Foo"
Expected = "BarBaz"
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected

'Extra test: empty text between delimiters
StartDelim = "Foo"
EndDelim = "BarBaz"
Expected = ""
Text = StartDelim & Expected & EndDelim & "FooBuxQuux"
Debug.Assert TextBetween(Text, StartDelim, EndDelim) = Expected
End Sub
