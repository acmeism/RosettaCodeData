Dim As String*11 lista(6) => {"abracadabra","seesaw","pop","grrrrrr","up","a"}

Function bestShuffle(s1 As String) As String
    Dim As String s2 = s1
    Dim As Integer i, j, i1, j1
    For i = 1 To Len(s2)
        For j =  1 To Len(s2)
            If (i <> j) And (Mid(s2,i,1) <> Mid(s1,j,1)) And (Mid(s2,j,1) <> Mid(s1,i,1)) Then
                If j < i Then i1 = j : j1 = i Else i1 = i : j1 = j
                s2 = Left(s2,i1-1) + Mid(s2,j1,1) + Mid(s2,i1+1,(j1-i1)-1) + Mid(s2,i1,1) + Mid(s2,j1+1)
            End If
        Next j
    Next i
    bestShuffle = s2
End Function

Dim As String palabra, bs
Dim As Integer puntos
For b As Integer = 0 To Ubound(lista)-1
    palabra  = lista(b)
    bs = bestShuffle(palabra)
    puntos = 0
    For i As Integer = 1 To Len(palabra)
        If Mid(palabra,i,1) = Mid(bs,i,1) Then puntos += 1
    Next i
    Print palabra; " ==> "; bs; "  (puntuaci¢n:"; puntos; ")"
Next b
Sleep
