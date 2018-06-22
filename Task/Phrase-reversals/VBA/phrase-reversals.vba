Option Explicit

Sub Main_Phrase_Reversals()
Const PHRASE As String = "rosetta code phrase reversal"
    Debug.Print "Original String              : " & PHRASE
    Debug.Print "Reverse String               : " & Reverse_String(PHRASE)
    Debug.Print "Reverse each individual word : " & Reverse_each_individual_word(PHRASE)
    Debug.Print "Reverse order of each word   : " & Reverse_the_order_of_each_word(PHRASE)
End Sub

Function Reverse_String(strPhrase As String) As String
    Reverse_String = StrReverse(strPhrase)
End Function

Function Reverse_each_individual_word(strPhrase As String) As String
Dim Words, i&, strTemp$
    Words = Split(strPhrase, " ")
    For i = 0 To UBound(Words)
        Words(i) = Reverse_String(CStr(Words(i)))
    Next i
    Reverse_each_individual_word = Join(Words, " ")
End Function

Function Reverse_the_order_of_each_word(strPhrase As String) As String
Dim Words, i&, strTemp$

    Words = Split(strPhrase, " ")
    For i = UBound(Words) To 0 Step -1
        strTemp = strTemp & " " & Words(i)
    Next i
    Reverse_the_order_of_each_word = Trim(strTemp)
End Function
