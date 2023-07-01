Module Task2
    Iterator Function ChaoticBankSocietySingle() As IEnumerable(Of Single)
        Dim balance As Single = Math.E - 1
        Dim year As Integer = 1

        Do
            balance = (balance * year) - 1
            Yield balance
            year += 1
        Loop
    End Function
    Iterator Function ChaoticBankSocietyDouble() As IEnumerable(Of Double)
        Dim balance As Double = Math.E - 1
        Dim year As Integer = 1

        Do
            balance = (balance * year) - 1
            Yield balance
            year += 1
        Loop
    End Function

    Iterator Function ChaoticBankSocietyDecimal() As IEnumerable(Of Decimal)
        ' 27! is the largest factorial decimal can represent.
        Dim balance As Decimal = CalculateEDecimal(27) - Decimal.One
        Dim year As Integer = 1

        Do
            balance = (balance * year) - Decimal.One
            Yield balance
            year += 1
        Loop
    End Function

#If USE_BIGRATIONAL Then
    Iterator Function ChaoticBankSocietyRational() As IEnumerable(Of BigRational)
        ' 100 iterations is precise enough for 25 years.
        Dim balance As BigRational = CalculateEBigRational(100) - BigRational.One
        Dim year As Integer = 1

        Do
            balance = (balance * year) - BigRational.One
            Yield balance
            year += 1
        Loop
    End Function
#Else
    Iterator Function ChaoticBankSocietyRational() As IEnumerable(Of BigRational)
        Do
            Yield Nothing
        Loop
    End Function
#End If

    Function CalculateEDecimal(terms As Integer) As Decimal
        Dim e As Decimal = 1
        Dim fact As Decimal = 1

        For i As Integer = 1 To terms
            fact *= i
            e += Decimal.One / fact
        Next

        Return e
    End Function

#If USE_BIGRATIONAL Then
    Function CalculateEBigRational(terms As Integer) As BigRational
        Dim e As BigRational = 1
        Dim fact As BigInteger = 1

        For i As Integer = 1 To terms
            fact *= i
            e += BigRational.Invert(fact)
        Next

        Return e
    End Function
#End If

    <Conditional("INCREASED_LIMITS")>
    Sub IncreaseMaxYear(ByRef year As Integer)
        year = 40
    End Sub

    Sub ChaoticBankSociety()
        Console.WriteLine("Chaotic Bank Society:")
        Console.WriteLine(Headings)

        Dim maxYear As Integer = 25
        IncreaseMaxYear(maxYear)

        Dim i As Integer = 0
        For Each x In ChaoticBankSocietySingle().
                      Zip(ChaoticBankSocietyDouble(), Function(sn, db) (sn, db)).
                      Zip(ChaoticBankSocietyDecimal(), Function(a, dm) (a.sn, a.db, dm)).
                      Zip(ChaoticBankSocietyRational(), Function(a, br) (a.sn, a.db, a.dm, br))
            If i >= maxYear Then Exit For
            Console.WriteLine(FormatOutput(i + 1, x))
            i += 1
        Next
    End Sub
End Module
