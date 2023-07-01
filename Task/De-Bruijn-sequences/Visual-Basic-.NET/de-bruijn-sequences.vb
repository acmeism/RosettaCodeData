Imports System.Text

Module Module1

    ReadOnly DIGITS As String = "0123456789"

    Function DeBruijn(k As Integer, n As Integer) As String
        Dim alphabet = DIGITS.Substring(0, k)
        Dim a(k * n) As Byte
        Dim seq As New List(Of Byte)
        Dim db As Action(Of Integer, Integer) = Sub(t As Integer, p As Integer)
                                                    If t > n Then
                                                        If n Mod p = 0 Then
                                                            Dim seg = New ArraySegment(Of Byte)(a, 1, p)
                                                            seq.AddRange(seg)
                                                        End If
                                                    Else
                                                        a(t) = a(t - p)
                                                        db(t + 1, p)
                                                        Dim j = a(t - p) + 1
                                                        While j < k
                                                            a(t) = j
                                                            db(t + 1, t)
                                                            j += 1
                                                        End While
                                                    End If
                                                End Sub
        db(1, 1)
        Dim buf As New StringBuilder
        For Each i In seq
            buf.Append(alphabet(i))
        Next
        Dim b = buf.ToString
        Return b + b.Substring(0, n - 1)
    End Function

    Function AllDigits(s As String) As Boolean
        For Each c In s
            If c < "0" OrElse "9" < c Then
                Return False
            End If
        Next
        Return True
    End Function

    Sub Validate(db As String)
        Dim le = db.Length
        Dim found(10000) As Integer
        Dim errs As New List(Of String)
        ' Check all strings of 4 consecutive digits within 'db'
        ' to see if all 10,000 combinations occur without duplication.
        For i = 1 To le - 3
            Dim s = db.Substring(i - 1, 4)
            If (AllDigits(s)) Then
                Dim n As Integer = Nothing
                Integer.TryParse(s, n)
                found(n) += 1
            End If
        Next
        For i = 1 To 10000
            If found(i - 1) = 0 Then
                errs.Add(String.Format("    PIN number {0,4} missing", i - 1))
            ElseIf found(i - 1) > 1 Then
                errs.Add(String.Format("    PIN number {0,4} occurs {1} times", i - 1, found(i - 1)))
            End If
        Next
        Dim lerr = errs.Count
        If lerr = 0 Then
            Console.WriteLine("  No errors found")
        Else
            Dim pl = If(lerr = 1, "", "s")
            Console.WriteLine("  {0} error{1} found:", lerr, pl)
            errs.ForEach(Sub(x) Console.WriteLine(x))
        End If
    End Sub

    Function Reverse(s As String) As String
        Dim arr = s.ToCharArray
        Array.Reverse(arr)
        Return New String(arr)
    End Function

    Sub Main()
        Dim db = DeBruijn(10, 4)
        Dim le = db.Length

        Console.WriteLine("The length of the de Bruijn sequence is {0}", le)
        Console.WriteLine(vbNewLine + "The first 130 digits of the de Bruijn sequence are: {0}", db.Substring(0, 130))
        Console.WriteLine(vbNewLine + "The last 130 digits of the de Bruijn sequence are: {0}", db.Substring(le - 130, 130))

        Console.WriteLine(vbNewLine + "Validating the deBruijn sequence:")
        Validate(db)

        Console.WriteLine(vbNewLine + "Validating the reversed deBruijn sequence:")
        Validate(Reverse(db))

        Dim bytes = db.ToCharArray
        bytes(4443) = "."
        db = New String(bytes)
        Console.WriteLine(vbNewLine + "Validating the overlaid deBruijn sequence:")
        Validate(db)
    End Sub

End Module
