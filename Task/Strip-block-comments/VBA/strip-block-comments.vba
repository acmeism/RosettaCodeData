'strip block comment NESTED comments
'multi line comments
'and what if there are string literals with these delimeters?
'------------------------
'delimeters for Block Comment can be specified, exactly two characters each
'Three states: Block_Comment, String_Literal, Other_Text
'Globals:
Dim t As String 'target string
Dim s() As Byte 'source array
Dim j As Integer 'index into the source string s, converted to byte array
Dim SourceLength As Integer 'of a base 0 array, so last byte is SourceLength - 1
Dim flag As Boolean
Private Sub Block_Comment(sOpBC As String, sClBC As String)
    'inside a block comment, expecting close block comment delimeter
    flag = False
    Do While j < SourceLength - 2
        Select Case s(j)
            Case Asc(Left(sOpBC, 1))
                If s(j + 1) = Asc(Right(sOpBC, 1)) Then
                    'open block NESTED comment delimeter found
                    j = j + 2
                    Block_Comment sOpBC, sClBC
                End If
            Case Asc(Left(sClBC, 1))
                If s(j + 1) = Asc(Right(sClBC, 1)) Then
                    'close block comment delimeter found
                    flag = True
                    j = j + 2
                    Exit Do
                End If
                'just a lone star
            Case Else
        End Select
        j = j + 1
    Loop
    If Not flag Then MsgBox "Error, missing close block comment delimeter"
End Sub
Private Sub String_Literal()
    'inside as string literal, expecting double quote as delimeter
    flag = False
    Do While j < SourceLength - 2
        If s(j) = Asc("""") Then
            If s(j + 1) = Asc("""") Then
                'found a double quote within a string literal
                t = t + Chr(s(j))
                j = j + 1
            Else
                'close string literal delimeter found
                flag = True
                t = t + Chr(s(j))
                j = j + 1
                Exit Do
            End If
        End If
        t = t + Chr(s(j))
        j = j + 1
    Loop
    If Not flag Then MsgBox "Error, missing closing string delimeter"
End Sub
Private Sub Other_Text(Optional sOpBC As String = "/*", Optional sClBC As String = "*/")
    If Len(sOpBC) <> 2 Then
        MsgBox "Error, open block comment delimeter must be 2" & _
        " characters long, got " & Len(sOpBC) & " characters"
        Exit Sub
    End If
    If Len(sClBC) <> 2 Then
        MsgBox "Error, close block comment delimeter must be 2" & _
        " characters long, got " & Len(sClBC) & " characters"
        Exit Sub
    End If
    Do While j < SourceLength - 1
        Select Case s(j)
            Case Asc(""""):
                t = t + Chr(s(j))
                j = j + 1
                String_Literal
            Case Asc(Left(sOpBC, 1))
                If s(j + 1) = Asc(Right(sOpBC, 1)) Then
                    'open block comment delimeter found
                    j = j + 2
                    Block_Comment sOpBC, sClBC
                Else
                    t = t + Chr(s(j))
                    j = j + 1
                End If
            Case Else
                t = t + Chr(s(j))
                j = j + 1
        End Select
    Loop
    If j = SourceLength - 1 Then t = t + Chr(s(j))
End Sub
Public Sub strip_block_comment()
    Dim n As String
    n = n & "/**" & vbCrLf
    n = n & "* Some comments /*NESTED COMMENT*/" & vbCrLf
    n = n & "* longer comments here that we can parse." & vbCrLf
    n = n & "*" & vbCrLf
    n = n & "* Rahoo" & vbCrLf
    n = n & "*/" & vbCrLf
    n = n & "mystring = ""This is the """"/*"""" open comment block mark.""" & vbCrLf
    'VBA converts two double quotes in a row within a string literal to a single double quote
    'see the output below. Quadruple double quotes become two double quotes within the string
    'to represent a single double quote within a string.
    n = n & "function subroutine() {" & vbCrLf
    n = n & "a = /* inline comment */ b + c ;" & vbCrLf
    n = n & "}" & vbCrLf
    n = n & "/*/ <-- tricky /*NESTED*/ comments */" & vbCrLf
    n = n & "" & vbCrLf
    n = n & "/**" & vbCrLf
    n = n & "* Another comment." & vbCrLf
    n = n & "*/" & vbCrLf
    n = n & "function something() {" & vbCrLf
    n = n & "}"
    s = StrConv(n, vbFromUnicode)
    j = 0
    t = ""
    SourceLength = Len(n)
    Other_Text 'The open and close delimeters for block comment are optional ;)
    Debug.Print "Original text:"
    Debug.Print String$(60, "-")
    Debug.Print n & vbCrLf
    Debug.Print "Text after deleting comment blocks, preserving string literals:"
    Debug.Print String$(60, "-")
    Debug.Print t
End Sub
