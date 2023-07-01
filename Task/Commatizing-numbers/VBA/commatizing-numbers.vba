Public Sub commatize(s As String, Optional sep As String = ",", Optional start As Integer = 1, Optional step As Integer = 3)
    Dim l As Integer: l = Len(s)
        For i = start To l
            If Asc(Mid(s, i, 1)) >= Asc("1") And Asc(Mid(s, i, 1)) <= Asc("9") Then
                For j = i + 1 To l + 1
                    If j > l Then
                        For k = j - 1 - step To i Step -step
                            s = Mid(s, 1, k) & sep & Mid(s, k + 1, l - k + 1)
                            l = Len(s)
                        Next k
                        Exit For
                    Else
                        If (Asc(Mid(s, j, 1)) < Asc("0") Or Asc(Mid(s, j, 1)) > Asc("9")) Then
                            For k = j - 1 - step To i Step -step
                                s = Mid(s, 1, k) & sep & Mid(s, k + 1, l - k + 1)
                                l = Len(s)
                            Next k
                            Exit For
                        End If
                    End If
                Next j
                Exit For
            End If
        Next i
        Debug.Print s
    End Sub
Public Sub main()
    commatize "pi=3.14159265358979323846264338327950288419716939937510582097494459231", " ", 6, 5
    commatize "The author has two Z$100000000000000 Zimbabwe notes (100 trillion).", "."
    commatize """-in Aus$+1411.8millions"""
    commatize "===US$0017440 millions=== (in 2000 dollars)"
    commatize "123.e8000 is pretty big."
    commatize "The land area of the earth is 57268900(29% of the surface) square miles."
    commatize "Ain't no numbers in this here words, nohow, no way, Jose."
    commatize "James was never known as 0000000007"
    commatize "Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe."
    commatize "   $-140000±100 millions."
    commatize "6/9/1946 was a good year for some."
End Sub
