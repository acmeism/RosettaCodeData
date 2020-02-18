Imports System.Text

Module Module1

    Class Zeckendorf
        Implements IComparable(Of Zeckendorf)

        Private Shared ReadOnly dig As String() = {"00", "01", "10"}
        Private Shared ReadOnly dig1 As String() = {"", "1", "10"}

        Private dVal As Integer = 0
        Private dLen As Integer = 0

        Public Sub New(Optional x As String = "0")
            Dim q = 1
            Dim i = x.Length - 1
            dLen = i \ 2

            Dim z = Asc("0")
            While i >= 0
                Dim a = Asc(x(i))
                dVal += (a - z) * q
                q *= 2
                i -= 1
            End While
        End Sub

        Private Sub A(n As Integer)
            Dim i = n
            While True
                If dLen < i Then
                    dLen = i
                End If
                Dim j = (dVal >> (i * 2)) And 3
                If j = 0 OrElse j = 1 Then
                    Return
                ElseIf j = 2 Then
                    If ((dVal >> ((i + 1) * 2)) And 1) <> 1 Then
                        Return
                    End If
                    dVal += 1 << (i * 2 + 1)
                    Return
                ElseIf j = 3 Then
                    Dim temp = 3 << (i * 2)
                    temp = temp Xor -1
                    dVal = dVal And temp
                    B((i + 1) * 2)
                End If
                i += 1
            End While
        End Sub

        Private Sub B(pos As Integer)
            If pos = 0 Then
                Inc()
                Return
            End If
            If ((dVal >> pos) And 1) = 0 Then
                dVal += 1 << pos
                A(pos \ 2)
                If pos > 1 Then
                    A(pos \ 2 - 1)
                End If
            Else
                Dim temp = 1 << pos
                temp = temp Xor -1
                dVal = dVal And temp
                B(pos + 1)
                B(pos - If(pos > 1, 2, 1))
            End If
        End Sub

        Private Sub C(pos As Integer)
            If ((dVal >> pos) And 1) = 1 Then
                Dim temp = 1 << pos
                temp = temp Xor -1
                dVal = dVal And temp
                Return
            End If
            C(pos + 1)
            If pos > 0 Then
                B(pos - 1)
            Else
                Inc()
            End If
        End Sub

        Public Function Inc() As Zeckendorf
            dVal += 1
            A(0)
            Return Me
        End Function

        Public Function Copy() As Zeckendorf
            Dim z As New Zeckendorf With {
                .dVal = dVal,
                .dLen = dLen
            }
            Return z
        End Function

        Public Sub PlusAssign(other As Zeckendorf)
            Dim gn = 0
            While gn < (other.dLen + 1) * 2
                If ((other.dVal >> gn) And 1) = 1 Then
                    B(gn)
                End If
                gn += 1
            End While
        End Sub

        Public Sub MinusAssign(other As Zeckendorf)
            Dim gn = 0
            While gn < (other.dLen + 1) * 2
                If ((other.dVal >> gn) And 1) = 1 Then
                    C(gn)
                End If
                gn += 1
            End While
            While (((dVal >> dLen * 2) And 3) = 0) OrElse dLen = 0
                dLen -= 1
            End While
        End Sub

        Public Sub TimesAssign(other As Zeckendorf)
            Dim na = other.Copy
            Dim nb = other.Copy
            Dim nt As Zeckendorf
            Dim nr As New Zeckendorf
            Dim i = 0
            While i < (dLen + 1) * 2
                If ((dVal >> i) And 1) > 0 Then
                    nr.PlusAssign(nb)
                End If
                nt = nb.Copy
                nb.PlusAssign(na)
                na = nt.Copy
                i += 1
            End While
            dVal = nr.dVal
            dLen = nr.dLen
        End Sub

        Public Function CompareTo(other As Zeckendorf) As Integer Implements IComparable(Of Zeckendorf).CompareTo
            Return dVal.CompareTo(other.dVal)
        End Function

        Public Overrides Function ToString() As String
            If dVal = 0 Then
                Return "0"
            End If

            Dim idx = (dVal >> (dLen * 2)) And 3
            Dim sb As New StringBuilder(dig1(idx))
            Dim i = dLen - 1
            While i >= 0
                idx = (dVal >> (i * 2)) And 3
                sb.Append(dig(idx))
                i -= 1
            End While
            Return sb.ToString
        End Function
    End Class

    Sub Main()
        Console.WriteLine("Addition:")
        Dim g As New Zeckendorf("10")
        g.PlusAssign(New Zeckendorf("10"))
        Console.WriteLine(g)
        g.PlusAssign(New Zeckendorf("10"))
        Console.WriteLine(g)
        g.PlusAssign(New Zeckendorf("1001"))
        Console.WriteLine(g)
        g.PlusAssign(New Zeckendorf("1000"))
        Console.WriteLine(g)
        g.PlusAssign(New Zeckendorf("10101"))
        Console.WriteLine(g)
        Console.WriteLine()

        Console.WriteLine("Subtraction:")
        g = New Zeckendorf("1000")
        g.MinusAssign(New Zeckendorf("101"))
        Console.WriteLine(g)
        g = New Zeckendorf("10101010")
        g.MinusAssign(New Zeckendorf("1010101"))
        Console.WriteLine(g)
        Console.WriteLine()

        Console.WriteLine("Multiplication:")
        g = New Zeckendorf("1001")
        g.TimesAssign(New Zeckendorf("101"))
        Console.WriteLine(g)
        g = New Zeckendorf("101010")
        g.PlusAssign(New Zeckendorf("101"))
        Console.WriteLine(g)
    End Sub

End Module
