Function add_commas(number As Integer) As String
    Dim As String s = Str(number)
    Dim As String result = ""
    Dim As Integer longitud = Len(s)
    For i As Integer = 1 To longitud
        result = Mid(s, longitud - i + 1, 1) & result
        If i Mod 3 = 0 And i <> longitud Then result = "," & result
    Next i
    Return result
End Function

Function invert_string(s As String) As String
    Dim As String result = ""
    For i As Integer = Len(s) To 1 Step -1
        result &= Mid(s, i, 1)
    Next i
    Return result
End Function

Sub custom_printf(formato As String, vars() As Any Ptr)
    Dim As Integer var_index = 0
    Dim As String result = ""
    Dim As Integer i = 1
    While i <= Len(formato)
        If Mid(formato, i, 1) = "%" Then
            i += 1
            Select Case Mid(formato, i, 1)
            Case "d"
                result &= Str(*Cast(Integer Ptr, vars(var_index)))
                var_index += 1
            Case "s"
                result &= *Cast(String Ptr, vars(var_index))
                var_index += 1
            Case "y"
                result &= add_commas(*Cast(Integer Ptr, vars(var_index)))
                var_index += 1
            Case "z"
                result &= invert_string(*Cast(String Ptr, vars(var_index)))
                var_index += 1
            Case Else
                result &= "%" & Mid(formato, i, 1)
                var_index += 1
            End Select
        Elseif Mid(formato, i, 1) = "\" And Mid(formato, i + 1, 1) = "n" Then
            result &= Chr(10)
            i += 1
        Else
            result &= Mid(formato, i, 1)
        End If
        i += 1
    Wend
    Print result
End Sub

' Example of use
Dim As Integer number = 12345
Dim As String spelled_out = "twelve thousand three hundred forty-five"
Dim As Any Ptr vars(3)
vars(0) = @number
vars(1) = @number
vars(2) = @spelled_out
vars(3) = @spelled_out
custom_printf(!"Integer %d with commas: %y\nSpelled out: %s\nInverted: %z\n", vars())

Sleep
