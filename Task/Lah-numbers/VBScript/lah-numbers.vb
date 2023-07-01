' Lah numbers - VBScript - 04/02/2021

    Function F(i,n)
        Dim c: c=CCur(i): If n>Len(c) Then F=Space(n-Len(c))&c Else F=c
    End Function 'F

    Function Fact(ByVal n)
        Dim res
        If n=0 Then
            Fact = 1
        Else
            res = 1
            While n>0
                res = res*n
                n = n-1
            Wend
            Fact = res
        End If
    End Function 'Fact

    Function Lah(n, k)
        If k=1 Then
            Lah = Fact(n)
        ElseIf k=n Then
            Lah = 1
        ElseIf k>n Then
            Lah=0
        ElseIf k < 1 Or n < 1 Then
            Lah = 0
        Else
            Lah = (Fact(n) * Fact(n-1)) / (Fact(k) * Fact(k-1)) / Fact(n-k)
        End If
    End Function 'Lah

    Sub Main()
        ns=12: p=10
        WScript.Echo "Unsigned Lah numbers: Lah(n,k):"
        buf = "n/k "
        For k=1 To ns
           buf = buf & F(k,p) & " "
        Next 'k
        WScript.Echo buf
        For n=1 To ns
           buf = F(n,3) & " "
            For k=1 To n
                l = Lah(n,k)
                buf = buf & F(l,p) & " "
            Next 'k
            WScript.Echo buf
        Next 'n
    End Sub 'Main

    Main()
