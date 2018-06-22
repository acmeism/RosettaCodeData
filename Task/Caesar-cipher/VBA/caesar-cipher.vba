Option Explicit

Sub Main_Caesar()
Dim ch As String
    ch = Caesar_Cipher("CAESAR: Who is it in the press that calls on me? I hear a tongue, shriller than all the music, Cry 'Caesar!' Speak; Caesar is turn'd to hear.", 14)
    Debug.Print ch
    Debug.Print Caesar_Cipher(ch, -14)
End Sub

Function Caesar_Cipher(sText As String, lngNumber As Long) As String
Dim Tbl, strGlob As String, strTemp As String, i As Long, bytAscii As Byte
  Const MAJ As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Const NB_LETTERS As Byte = 26
      Const DIFFASCIIMAJ As Byte = 65 - NB_LETTERS
        Const DIFFASCIIMIN As Byte = 97 - NB_LETTERS

    strTemp = sText
    If lngNumber < NB_LETTERS And lngNumber > NB_LETTERS * -1 Then
        strGlob = String(NB_LETTERS * 4, " ")
        LSet strGlob = MAJ & MAJ & MAJ
        Tbl = Split(StrConv(strGlob, vbUnicode), Chr(0))
        For i = 1 To Len(strTemp)
            If Mid(strTemp, i, 1) Like "[a-zA-Z]" Then
                bytAscii = Asc(Mid(strTemp, i, 1))
                If Mid(strTemp, i, 1) = Tbl(bytAscii - DIFFASCIIMAJ) Then
                    Mid(strTemp, i) = Tbl(bytAscii - DIFFASCIIMAJ + lngNumber)
                Else
                    Mid(strTemp, i) = LCase(Tbl(bytAscii - DIFFASCIIMIN + lngNumber))
                End If
            End If
        Next i
    End If
    Caesar_Cipher = strTemp
End Function
