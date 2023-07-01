Module Module1

    Function IndexOf(n As Integer, s As Integer()) As Integer
        For ii = 1 To s.Length
            Dim i = ii - 1
            If s(i) = n Then
                Return i
            End If
        Next
        Return -1
    End Function

    Function GetDigits(n As Integer, le As Integer, digits As Integer()) As Boolean
        While n > 0
            Dim r = n Mod 10
            If r = 0 OrElse IndexOf(r, digits) >= 0 Then
                Return False
            End If
            le -= 1
            digits(le) = r
            n \= 10
        End While
        Return True
    End Function

    Function RemoveDigit(digits As Integer(), le As Integer, idx As Integer) As Integer
        Dim pows = {1, 10, 100, 1000, 10000}
        Dim sum = 0
        Dim pow = pows(le - 2)
        For ii = 1 To le
            Dim i = ii - 1
            If i = idx Then
                Continue For
            End If
            sum += digits(i) * pow
            pow \= 10
        Next
        Return sum
    End Function

    Sub Main()
        Dim lims = {{12, 97}, {123, 986}, {1234, 9875}, {12345, 98764}}
        Dim count(5) As Integer
        Dim omitted(5, 10) As Integer
        Dim upperBound = lims.GetLength(0)
        For ii = 1 To upperBound
            Dim i = ii - 1
            Dim nDigits(i + 2 - 1) As Integer
            Dim dDigits(i + 2 - 1) As Integer
            Dim blank(i + 2 - 1) As Integer
            For n = lims(i, 0) To lims(i, 1)
                blank.CopyTo(nDigits, 0)
                Dim nOk = GetDigits(n, i + 2, nDigits)
                If Not nOk Then
                    Continue For
                End If
                For d = n + 1 To lims(i, 1) + 1
                    blank.CopyTo(dDigits, 0)
                    Dim dOk = GetDigits(d, i + 2, dDigits)
                    If Not dOk Then
                        Continue For
                    End If
                    For nixt = 1 To nDigits.Length
                        Dim nix = nixt - 1
                        Dim digit = nDigits(nix)
                        Dim dix = IndexOf(digit, dDigits)
                        If dix >= 0 Then
                            Dim rn = RemoveDigit(nDigits, i + 2, nix)
                            Dim rd = RemoveDigit(dDigits, i + 2, dix)
                            If (n / d) = (rn / rd) Then
                                count(i) += 1
                                omitted(i, digit) += 1
                                If count(i) <= 12 Then
                                    Console.WriteLine("{0}/{1} = {2}/{3} by omitting {4}'s", n, d, rn, rd, digit)
                                End If
                            End If
                        End If
                    Next
                Next
            Next
            Console.WriteLine()
        Next

        For i = 2 To 5
            Console.WriteLine("There are {0} {1}-digit fractions of which:", count(i - 2), i)
            For j = 1 To 9
                If omitted(i - 2, j) = 0 Then
                    Continue For
                End If
                Console.WriteLine("{0,6} have {1}'s omitted", omitted(i - 2, j), j)
            Next
            Console.WriteLine()
        Next
    End Sub

End Module
