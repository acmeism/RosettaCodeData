Public Sub BuildHTMLTable()
'simple HTML table, represented as a string matrix "cells"
Const nRows = 6
Const nCols = 4
Dim cells(1 To nRows, 1 To nCols) As String
Dim HTML As String 'the HTML table
Dim temp As String
Dim attr As String

' fill table
' first row with titles
cells(1, 1) = ""
cells(1, 2) = "X"
cells(1, 3) = "Y"
cells(1, 4) = "Z"
'next rows with index & random numbers
For i = 2 To nRows
  cells(i, 1) = Format$(i - 1)
  For j = 2 To nCols
    cells(i, j) = Format$(Int(Rnd() * 10000))
  Next j
Next i

'build the HTML
HTML = ""
For i = 1 To nRows
  temp = ""
  'first row as header row
  If i = 1 Then attr = "th" Else attr = "td"
  For j = 1 To nCols
    temp = temp & HTMLWrap(cells(i, j), attr)
  Next j
  HTML = HTML & HTMLWrap(temp, "tr")
Next i
HTML = HTMLWrap(HTML, "table", "style=""text-align:center; border: 1px solid""")
Debug.Print HTML
End Sub

Public Function HTMLWrap(s As String, tag As String, ParamArray attributes()) As String
  'returns string s wrapped in HTML tag with optional "attribute=value" strings
  'ex.: HTMLWrap("Link text", "a", "href=""http://www.somesite.org""")
  'returns: <a href="http://www.somesite.org">Link text</a>

  Dim sOpenTag As String
  Dim sClosingTag As String

  sOpenTag = "<" & tag
  For Each attr In attributes
    sOpenTag = sOpenTag & " " & attr
  Next
  sOpenTag = sOpenTag & ">"
  sClosingTag = "</" & tag & ">"
  HTMLWrap = sOpenTag & s & sClosingTag
End Function
