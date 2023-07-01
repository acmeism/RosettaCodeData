'Immutable Strings
Dim a = "Test string"
Dim b = a 'reference to same string
Dim c = New String(a.ToCharArray) 'new string, normally not used

'Mutable Strings
Dim x As New Text.StringBuilder("Test string")
Dim y = x 'reference
Dim z = New Text.StringBuilder(x.ToString) 'new string
