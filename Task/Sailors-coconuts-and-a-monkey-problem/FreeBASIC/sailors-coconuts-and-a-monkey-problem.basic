Dim As Integer cocos, marineros, nc, s, t

cocos = 11
For marineros = 2 To 9
    Dim As Integer oculta(marineros)
    cocos = (cocos \ marineros) * marineros + 1
    Do
        nc = cocos
        For s = 1 To marineros + 1
            If nc Mod marineros = 1 Then
                oculta(s-1) = nc \ marineros
                nc -= oculta(s-1) + 1
                If (s = marineros) And (nc Mod marineros = 0) Then
                    Print marineros; " sailors require a minimum of "; cocos; " coconuts"
                    For t = 1 To marineros
                        Print !"\tSailor "; t; " hides "; oculta(t - 1)
                    Next t
                    Print !"\tThe monkey gets "; marineros
                    Print !"\tFinally, each sailor takes "; (nc \ marineros) & Chr(10)
                    Exit Do
                End If
            Else
                Exit For
            End If
        Next s
        cocos += marineros
    Loop
Next marineros

Sleep
