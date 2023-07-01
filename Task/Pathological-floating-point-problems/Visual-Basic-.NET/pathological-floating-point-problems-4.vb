Module Task3
    Function SiegfriedRumpSingle(a As Single, b As Single) As Single
        Dim a2 = a * a,
            b2 = b * b,
            b4 = b2 * b2,
            b6 = b4 * b2

        ' Non-integral literals must be coerced to Single using the type suffix.
        Return 333.75F * b6 +
            (a2 * (
                11 * a2 * b2 -
                b6 -
                121 * b4 -
                2)) +
            5.5F * b4 * b4 +
            a / (2 * b)
    End Function

    Function SiegfriedRumpDouble(a As Double, b As Double) As Double
        Dim a2 = a * a,
            b2 = b * b,
            b4 = b2 * b2,
            b6 = b4 * b2

        ' Non-integral literals are Doubles by default.
        Return 333.75 * b6 +
            (a2 * (
                11 * a2 * b2 -
                b6 -
                121 * b4 -
                2)) +
            5.5 * b4 * b4 +
            a / (2 * b)
    End Function

    Function SiegfriedRumpDecimal(a As Decimal, b As Decimal) As Decimal
        Dim a2 = a * a,
            b2 = b * b,
            b4 = b2 * b2,
            b6 = b4 * b2

        ' The same applies for Decimal.
        Return 333.75D * b6 +
            (a2 * (
                11 * a2 * b2 -
                b6 -
                121 * b4 -
                2)) +
            5.5D * b4 * b4 +
            a / (2 * b)
    End Function

#If USE_BIGRATIONAL Then
    Function SiegfriedRumpRational(a As BigRational, b As BigRational) As BigRational
        ' Use mixed number constructor to maintain exact precision (333+3/4, 5+1/2).
        Dim c1 As New BigRational(333, 3, 4)
        Dim c2 As New BigRational(5, 1, 2)

        Dim a2 = a * a,
            b2 = b * b,
            b4 = b2 * b2,
            b6 = b4 * b2

        Return c1 * b6 +
            (a2 * (
                11 * a2 * b2 -
                b6 -
                121 * b4 -
                2)) +
            c2 * b4 * b4 +
            a / (2 * b)
    End Function
#Else
    Function SiegfriedRumpRational(a As Integer, b As Integer) As BigRational
        Return Nothing
    End Function
#End If

    Sub SiegfriedRump()
        Console.WriteLine("Siegfried Rump Formula:")
        Dim a As Integer = 77617
        Dim b As Integer = 33096

        Console.Write("Single: ")
        Dim sn As Single = SiegfriedRumpSingle(a, b)
        Console.WriteLine("{0:G9}", sn)
        Console.WriteLine()

        Console.Write("Double: ")
        Dim db As Double = SiegfriedRumpDouble(a, b)
        Console.WriteLine("{0:G17}", db)
        Console.WriteLine()

        Console.WriteLine("Decimal:")
        Dim dm As Decimal
        Try
            dm = SiegfriedRumpDecimal(a, b)
        Catch ex As OverflowException
            Console.WriteLine("Exception: " + ex.Message)
        End Try
        Console.WriteLine($"  {dm}")
        Console.WriteLine()

        Console.WriteLine("BigRational:")
        Dim br As BigRational = SiegfriedRumpRational(a, b)
        Console.WriteLine($"  Rounded: {CDec(br)}")
        Console.WriteLine($"  Exact: {br}")
    End Sub
End Module
