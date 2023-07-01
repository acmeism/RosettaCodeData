' Euler's sum of powers of 4 conjecture - Patrice Grandin - 17/05/2020

' x1^4  +  x2^4  +  x3^4  +  x4^4  =  x5^4

' Project\Add reference\Assembly\Framework   System.Numerics
Imports System.Numerics 'BigInteger

Public Class EulerPower4Sum

    Private Sub MyForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Dim t1, t2 As DateTime
        t1 = Now
        EulerPower45Sum()   '16.7 sec
        'EulerPower44Sum()   '633 years !!
        t2 = Now
        Console.WriteLine((t2 - t1).TotalSeconds & " sec")
    End Sub 'Load

    Private Sub EulerPower45Sum()
        '30^4 + 120^4 + 272^4 + 315^4 = 353^4
        Const MaxN = 360
        Dim i, j, i1, i2, i3, i4, i5 As Int32
        Dim p4(MaxN), n, sumx As Int64
        Debug.Print(">EulerPower45Sum")
        For i = 1 To MaxN
            n = 1
            For j = 1 To 4
                n *= i
            Next j
            p4(i) = n
        Next i
        For i1 = 1 To MaxN
            If i1 Mod 5 = 0 Then Debug.Print(">i1=" & i1)
            For i2 = i1 To MaxN
                For i3 = i2 To MaxN
                    For i4 = i3 To MaxN
                        sumx = p4(i1) + p4(i2) + p4(i3) + p4(i4)
                        i5 = i4 + 1
                        While i5 <= MaxN AndAlso p4(i5) <= sumx
                            If p4(i5) = sumx Then
                                Debug.Print(i1 & " " & i2 & " " & i3 & " " & i4 & " " & i5)
                                Exit Sub
                            End If
                            i5 += 1
                        End While
                    Next i4
                Next i3
            Next i2
        Next i1
        Debug.Print("Not found!")
    End Sub 'EulerPower45Sum

    Private Sub EulerPower44Sum()
        '95800^4 + 217519^4 + 414560^4 = 422481^4
        Const MaxN = 500000   '500000^4 => decimal(23) => binary(76) !!
        Dim i, j, i1, i2, i3, i4 As Int32
        Dim p4(MaxN), n, sumx As BigInteger
        Dim t0 As DateTime
        Debug.Print(">EulerPower44Sum")
        For i = 1 To MaxN
            n = 1
            For j = 1 To 4
                n *= i
            Next j
            p4(i) = n
        Next i
        t0 = Now
        For i1 = 1 To MaxN
            Debug.Print(">i1=" & i1)
            For i2 = i1 To MaxN
                If i2 Mod 100 = 0 Then Debug.Print(">i1=" & i1 & " i2=" & i2 & " " & Int((Now - t0).TotalSeconds) & " sec")
                For i3 = i2 To MaxN
                    sumx = p4(i1) + p4(i2) + p4(i3)
                    i4 = i3 + 1
                    While i4 <= MaxN AndAlso p4(i4) <= sumx
                        If p4(i4) = sumx Then
                            Debug.Print(i1 & " " & i2 & " " & i3 & " " & i4)
                            Exit Sub
                        End If
                        i4 += 1
                    End While
                Next i3
            Next i2
        Next i1
        Debug.Print("Not found!")
    End Sub 'EulerPower44Sum

End Class
