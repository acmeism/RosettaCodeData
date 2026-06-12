Option Explicit
Public Function Decode(s As String) As String
    Dim i As Integer, j As Integer, r As Byte
    Dim FirstByte As Byte, SecndByte As Byte, ThirdByte As Byte
    Dim SixBitArray() As Byte, ResultString As String, Token As String
    Dim Counter As Integer, InputLength As Integer
    InputLength = Len(s)
    ReDim SixBitArray(InputLength + 1)
    j = 1 'j counts the tokens excluding cr, lf and padding
    For i = 1 To InputLength 'loop over s and translate tokens to 0-63
        Token = Mid(s, i, 1)
        Select Case Token
            Case "A" To "Z"
                SixBitArray(j) = Asc(Token) - Asc("A")
                j = j + 1
            Case "a" To "z"
                SixBitArray(j) = Asc(Token) - Asc("a") + 26
                j = j + 1
            Case "0" To "9"
                SixBitArray(j) = Asc(Token) - Asc("0") + 52
                j = j + 1
            Case "+"
                SixBitArray(j) = 62
                j = j + 1
            Case "/"
                SixBitArray(j) = 63
                j = j + 1
            Case "="
                'padding'
            Case Else
                'cr and lf
        End Select
    Next i
    r = (j - 1) Mod 4
    Counter = 1
    For i = 1 To (j - 1) \ 4 'loop over the six bit byte quadruplets
        FirstByte = SixBitArray(Counter) * 4 + SixBitArray(Counter + 1) \ 16
        SecndByte = (SixBitArray(Counter + 1) Mod 16) * 16 + SixBitArray(Counter + 2) \ 4
        ThirdByte = (SixBitArray(Counter + 2) Mod 4) * 64 + SixBitArray(Counter + 3)
        ResultString = ResultString & Chr(FirstByte) & Chr(SecndByte) & Chr(ThirdByte)
        Counter = Counter + 4
    Next i
    Select Case r
        Case 3
            FirstByte = SixBitArray(Counter) * 4 + SixBitArray(Counter + 1) \ 16
            SecndByte = (SixBitArray(Counter + 1) Mod 16) * 16 + SixBitArray(Counter + 2) \ 4
            ResultString = ResultString & Chr(FirstByte) & Chr(SecndByte)
        Case 2
            FirstByte = SixBitArray(Counter) * 4 + SixBitArray(Counter + 1) \ 16
            ResultString = ResultString & Chr(FirstByte)
    End Select
    Decode = ResultString
End Function
Public Function Encode(s As String) As String
    Dim InputLength As Integer, FirstByte As Byte, SecndByte As Byte, ThirdByte As Byte, r As Byte
    Dim LineNumber As Integer, z As Integer, q() As String, ResultString As String
    Dim FullLines As Integer, LastLineLength As Integer, Counter As Integer
    q = Split("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j," & _
        "k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,+,/", ",", -1, vbTextCompare)
    InputLength = Len(s)
    r = InputLength Mod 3
    FullLines = ((InputLength - r) / 3) \ 20 + 1: LastLineLength = (InputLength - r) / 3 Mod 20 - 1
    Counter = 1
    For LineNumber = 1 To FullLines
        For z = 0 To IIf(LineNumber < FullLines, 19, LastLineLength) 'loop over the byte triplets
            FirstByte = Asc(Mid(s, Counter, 1))
            SecndByte = Asc(Mid(s, Counter + 1, 1))
            ThirdByte = Asc(Mid(s, Counter + 2, 1))
            Counter = Counter + 3
            ResultString = ResultString & q(FirstByte \ 4) & q((FirstByte Mod 4) * 16 + _
                (SecndByte \ 16)) & q((SecndByte Mod 16) * 4 + (ThirdByte \ 64)) & q(ThirdByte Mod 64)
        Next z
        If LineNumber < FullLines Then ResultString = ResultString & vbCrLf
    Next LineNumber
    Select Case r
        Case 2
            FirstByte = Asc(Mid(s, Counter, 1))
            SecndByte = Asc(Mid(s, Counter + 1, 1))
            ResultString = ResultString & q(FirstByte \ 4) & q((FirstByte Mod 4) * 16 + _
                (SecndByte \ 16)) & q((SecndByte Mod 16) * 4) & "="
        Case 1
            FirstByte = Asc(Mid(s, Counter, 1))
            ResultString = ResultString & q(FirstByte \ 4) & q((FirstByte Mod 4) * 16) & "=="
    End Select
    Encode = ResultString
End Function
Private Function ReadWebFile(ByVal vWebFile As String) As String
    'adapted from https://www.ozgrid.com/forum/forum/help-forums/excel-general/86714-vba-read-text-file-from-a-url
    Dim oXMLHTTP As Object, i As Long, vFF As Long, oResp() As Byte
    Set oXMLHTTP = CreateObject("MSXML2.XMLHTTP")
    oXMLHTTP.Open "GET", vWebFile, False
    oXMLHTTP.send
    Do While oXMLHTTP.readyState <> 4: DoEvents: Loop
    oResp = oXMLHTTP.responseBody 'Returns the results as a byte array
    ReadWebFile = StrConv(oResp, vbUnicode)
    Set oXMLHTTP = Nothing
End Function
Public Sub Task()
    Dim In_ As String, Out As String, bIn As String
    Dim filelength As Integer
    Dim i As Integer
    In_ = ReadWebFile("http://rosettacode.org/favicon.ico")
    Out = Encode(In_)
    bIn = Decode(Out)
    Debug.Print "The first eighty and last eighty characters after encoding:"
    Debug.Print Left(Out, 82) & "..." & vbCrLf & Join(Split(Right(Out, 82), vbCrLf), "")
    Debug.Print "Result of string comparison of input and decoded output: " & StrComp(In_, bIn, vbBinaryCompare)
    Debug.Print "A zero indicates both strings are equal."
End Sub
