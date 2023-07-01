Imports System.Globalization
Imports System.Numerics
Imports Numerics

#Const USE_BIGRATIONAL = True
#Const BANDED_ROWS = True
#Const INCREASED_LIMITS = True

#If Not USE_BIGRATIONAL Then
' Mock structure to make test code work.
Structure BigRational
    Overrides Function ToString() As String
        Return "NOT USING BIGRATIONAL"
    End Function
    Shared Narrowing Operator CType(value As BigRational) As Decimal
        Return -1
    End Operator
End Structure
#End If

Module Common
    Public Const FMT_STR = "{0,4}   {1,-15:G9}   {2,-24:G17}   {3,-32}   {4,-32}"
    Public ReadOnly Property Headings As String =
        String.Format(CultureInfo.InvariantCulture,
                      FMT_STR,
                      {"N", "Single", "Double", "Decimal", "BigRational (rounded as decimal)"})

    <Conditional("BANDED_ROWS")>
    Sub SetConsoleFormat(n As Integer)
        If n Mod 2 = 0 Then
            Console.BackgroundColor = ConsoleColor.Black
            Console.ForegroundColor = ConsoleColor.White
        Else
            Console.BackgroundColor = ConsoleColor.White
            Console.ForegroundColor = ConsoleColor.Black
        End If
    End Sub

    Function FormatOutput(n As Integer, x As (sn As Single, db As Double, dm As Decimal, br As BigRational)) As String
        SetConsoleFormat(n)
        Return String.Format(CultureInfo.CurrentCulture, FMT_STR, n, x.sn, x.db, x.dm, CDec(x.br))
    End Function

    Sub Main()
        WrongConvergence()
        Console.WriteLine()
        ChaoticBankSociety()

        Console.WriteLine()
        SiegfriedRump()

        SetConsoleFormat(0)
    End Sub
End Module
