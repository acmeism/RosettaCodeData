Imports System.Runtime.CompilerServices
Imports System.Text

Module Module1

    <Extension()>
    Function AsString(Of T)(c As ICollection(Of T), Optional format As String = "{0}") As String
        Dim sb As New StringBuilder("[")
        Dim it = c.GetEnumerator()
        If it.MoveNext() Then
            sb.AppendFormat(format, it.Current)
        End If
        While it.MoveNext()
            sb.Append(", ")
            sb.AppendFormat(format, it.Current)
        End While
        Return sb.Append("]").ToString()
    End Function

    Function Median(x As Double(), start As Integer, endInclusive As Integer) As Double
        Dim size = endInclusive - start + 1
        If size <= 0 Then
            Throw New ArgumentException("Array slice cannot be empty")
        End If
        Dim m = start + size \ 2
        Return If(size Mod 2 = 1, x(m), (x(m - 1) + x(m)) / 2.0)
    End Function

    Function Fivenum(x As Double()) As Double()
        For Each d In x
            If Double.IsNaN(d) Then
                Throw New ArgumentException("Unable to deal with arrays containing NaN")
            End If
        Next

        Array.Sort(x)
        Dim result(4) As Double

        result(0) = x.First()
        result(2) = Median(x, 0, x.Length - 1)
        result(4) = x.Last()

        Dim m = x.Length \ 2
        Dim lowerEnd = If(x.Length Mod 2 = 1, m, m - 1)

        result(1) = Median(x, 0, lowerEnd)
        result(3) = Median(x, m, x.Length - 1)

        Return result
    End Function

    Sub Main()
        Dim x1 = {
            New Double() {15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0},
            New Double() {36.0, 40.0, 7.0, 39.0, 41.0, 15.0},
            New Double() {
                     0.14082834, 0.0974879, 1.73131507, 0.87636009, -1.95059594, 0.73438555,
                    -0.03035726, 1.4667597, -0.74621349, -0.72588772, 0.6390516, 0.61501527,
                    -0.9898378, -1.00447874, -0.62759469, 0.66206163, 1.04312009, -0.10305385,
                     0.75775634, 0.32566578
            }
        }
        For Each x In x1
            Dim result = Fivenum(x)
            Console.WriteLine(result.AsString("{0:F8}"))
        Next
    End Sub

End Module
