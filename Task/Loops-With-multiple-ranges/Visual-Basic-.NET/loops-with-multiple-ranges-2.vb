Imports System.Globalization

Partial Module Program
    Sub Main()
        ' All variables are inferred to be of type Integer.
        Dim prod = 1,
            sum = 0,
            x = +5,
            y = -5,
            z = -2,
            one = 1,
            three = 3,
            seven = 7

        ' The exponent operator compiles to a call to Math.Pow, which returns Double, and so must be converted back to Integer.
        For Each j In Range(-three,       CInt(3 ^ 3),        3     ).
               Concat(Range(-seven,       +seven,             x     )).
               Concat(Range(555,          550 - y                   )).
               Concat(Range(22,           -28,                -three)).
               Concat(Range(1927,         1939                      )).
               Concat(Range(x,            y,                  z     )).
               Concat(Range(CInt(11 ^ x), CInt(11 ^ x) + one        ))

            sum = sum + Math.Abs(j)
            If Math.Abs(prod) < 2 ^ 27 AndAlso j <> 0 Then prod = prod * j
        Next

        ' The invariant format info by default has two decimal places.
        Dim format As New NumberFormatInfo() With {
            .NumberDecimalDigits = 0
        }

        Console.WriteLine(String.Format(format, " sum= {0:N}", sum))
        Console.WriteLine(String.Format(format, "prod= {0:N}", prod))
    End Sub
End Module
