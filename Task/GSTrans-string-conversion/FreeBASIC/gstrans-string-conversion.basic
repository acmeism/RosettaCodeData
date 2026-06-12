Function GSTransEncodeChar(c As Ubyte) As String
    Dim As String resultchars = ""
    If c <= 31 Then
        resultchars &= "|" & Chr(64 + c)
    Elseif c = Asc("""") Then
        resultchars &= "|"""
    Elseif c = Asc("|") Then
        resultchars &= "||"
    Elseif c = 127 Then
        resultchars &= "|?"
    Elseif c >= 128 Then    ' then recurse after subtracting 128
        resultchars &= "|!" & GSTransEncodeChar(c - 128)
    Else
        resultchars &= Chr(c)
    End If
    Return resultchars
End Function

Function GSTransEncode(cad As String) As String
    Dim As String result = ""
    For i As Integer = 1 To Len(cad)
        result &= GSTransEncodeChar(Asc(Mid(cad, i, 1)))
    Next
    Return result
End Function

Function GSTransDecode(cad As String) As String
    Dim As String result = ""
    Dim As Boolean gotbar = False, gotbang = False
    Dim As Integer i, j, bangadd = 0
    For i = 1 To Len(cad)
        Dim As Ubyte c = Asc(Mid(cad, i, 1))
        If gotbang Then
            If c = Asc("|") Then
                bangadd = 128
                gotbar = True
            Else
                result &= Chr(c + 128)
            End If
            gotbang = False
        Elseif gotbar Then
            Select Case c
            Case Asc("?")
                result &= Chr(127 + bangadd)
            Case Asc("!")
                gotbang = True
            Case Asc("|"), Asc(""""), Asc("<")
                result &= Chr(c + bangadd)
            Case Asc("["), Asc("{")
                result &= Chr(27 + bangadd)
            Case Asc("\")
                result &= Chr(28 + bangadd)
            Case Asc("]"), Asc("}")
                result &= Chr(29 + bangadd)
            Case Asc("^"), Asc("~")
                result &= Chr(30 + bangadd)
            Case Asc("_"), Asc("`")
                result &= Chr(31 + bangadd)
            Case Else
                j = Asc(Ucase(Chr(c))) - 64 + bangadd
                result &= Iif(j >= 0, Chr(j), Chr(c))
            End Select
            gotbar = False
            bangadd = 0
        Elseif c = Asc("|") Then
            gotbar = True
        Else
            result &= Chr(c)
        End If
    Next
    Return result
End Function

' test cases
Dim As Integer i, j
Dim As String TESTS(1) = {"ALERT|G", "|LHello|G|J|M"}
Dim As String RAND_TESTS(7)
For i = 0 To Ubound(RAND_TESTS)
    Dim As String rand_str = ""
    For j = 1 To 10
        rand_str &= Chr(Int(Rnd * 256))
    Next
    RAND_TESTS(i) = rand_str
Next
Dim As String DECODE_TESTS(4) = {_
"|LHello|G|J|M", "|m|j|@|e|!t|m|!|?", "abc|1de|5f", "quoted|text", "\r\n\0\x05\xf4\r\xff" }

For i = 0 To Ubound(TESTS)
    Dim As String t = TESTS(i)
    Dim As String encoded = GSTransEncode(t)
    Dim As String decoded = GSTransDecode(encoded)
    Print "String "; t; " encoded is: "; encoded; ", decoded is: "; decoded
    If t <> decoded Then
        Print "Error: Decoded string does not match original"
    End If
Next

For i = 0 To Ubound(RAND_TESTS)
    Dim As String t = RAND_TESTS(i)
    Dim As String encoded = GSTransEncode(t)
    Dim As String decoded = GSTransDecode(encoded)
    Print "String "; t; " encoded is: "; encoded; ", decoded is: "; decoded
    If t <> decoded Then
        Print "Error: Decoded string does not match original"
    End If
Next

For i = 0 To Ubound(TESTS)
    Dim As String enc = DECODE_TESTS(i)
    Print !"\nThe encoded string "; enc; " is decoded as: "; GSTransDecode(enc);
Next

Sleep
