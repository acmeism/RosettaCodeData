Imports System.Runtime.CompilerServices
Imports System.Text

Module Module1

    Class Crutch
        Public ReadOnly len As Integer
        Public s() As Integer
        Public i As Integer

        Public Sub New(len As Integer)
            Me.len = len
            s = New Integer(len - 1) {}
            i = 0
        End Sub

        Public Sub Repeat(count As Integer)
            For j = 1 To count
                i += 1
                If i = len Then
                    Return
                End If
                s(i) = s(i - 1)
            Next
        End Sub
    End Class

    <Extension()>
    Public Function NextInCycle(self As Integer(), index As Integer) As Integer
        Return self(index Mod self.Length)
    End Function

    <Extension()>
    Public Function Kolakoski(self As Integer(), len As Integer) As Integer()
        Dim c As New Crutch(len)

        Dim k = 0
        While c.i < len
            c.s(c.i) = self.NextInCycle(k)
            If c.s(k) > 1 Then
                c.Repeat(c.s(k) - 1)
            End If
            c.i += 1
            If c.i = len Then
                Return c.s
            End If
            k += 1
        End While

        Return c.s
    End Function

    <Extension()>
    Public Function PossibleKolakoski(self As Integer()) As Boolean
        Dim rle(self.Length) As Integer
        Dim prev = self(0)
        Dim count = 1
        Dim pos = 0
        For i = 2 To self.Length
            If self(i - 1) = prev Then
                count += 1
            Else
                rle(pos) = count
                pos += 1

                count = 1
                prev = self(i - 1)
            End If
        Next
        REM no point adding final 'count' to rle as we're not going to compare it anyway
        For i = 1 To pos
            If rle(i - 1) <> self(i - 1) Then
                Return False
            End If
        Next
        Return True
    End Function

    <Extension()>
    Public Function AsString(self As Integer()) As String
        Dim sb As New StringBuilder("[")
        Dim it = self.GetEnumerator()
        If it.MoveNext Then
            sb.Append(it.Current)
        End If
        While it.MoveNext
            sb.Append(", ")
            sb.Append(it.Current)
        End While
        Return sb.Append("]").ToString
    End Function

    Sub Main()
        Dim ias()() As Integer = {New Integer() {1, 2}, New Integer() {2, 1}, New Integer() {1, 3, 1, 2}, New Integer() {1, 3, 2, 1}}
        Dim lens() As Integer = {20, 20, 30, 30}

        For i = 1 To ias.Length
            Dim len = lens(i - 1)
            Dim kol = ias(i - 1).Kolakoski(len)

            Console.WriteLine("First {0} members of the sequence by {1}: ", len, ias(i - 1).AsString)
            Console.WriteLine(kol.AsString)
            Console.WriteLine("Possible Kolakoski sequence? {0}", kol.PossibleKolakoski)
            Console.WriteLine()
        Next
    End Sub

End Module
