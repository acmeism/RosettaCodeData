Imports System.Runtime.CompilerServices
Imports System.Linq.Enumerable

Module Module1
    <Extension()>
    Function DelimitWith(Of T)(source As IEnumerable(Of T), Optional seperator As String = " ") As String
        Return String.Join(seperator, source)
    End Function

    Private Class SubMatrix
        Private ReadOnly source As Integer(,)
        Private ReadOnly prev As SubMatrix
        Private ReadOnly replaceColumn As Integer()

        Public Sub New(source As Integer(,), replaceColumn As Integer())
            Me.source = source
            Me.replaceColumn = replaceColumn
            prev = Nothing
            ColumnIndex = -1
            Size = replaceColumn.Length
        End Sub

        Public Sub New(prev As SubMatrix, Optional deletedColumnIndex As Integer = -1)
            source = Nothing
            replaceColumn = Nothing
            Me.prev = prev
            ColumnIndex = deletedColumnIndex
            Size = prev.Size - 1
        End Sub

        Public Property ColumnIndex As Integer
        Public ReadOnly Property Size As Integer

        Default Public ReadOnly Property Index(row As Integer, column As Integer) As Integer
            Get
                If Not IsNothing(source) Then
                    Return If(column = ColumnIndex, replaceColumn(row), source(row, column))
                Else
                    Return prev(row + 1, If(column < ColumnIndex, column, column + 1))
                End If
            End Get
        End Property

        Public Function Det() As Integer
            If Size = 1 Then Return Me(0, 0)
            If Size = 2 Then Return Me(0, 0) * Me(1, 1) - Me(0, 1) * Me(1, 0)
            Dim m As New SubMatrix(Me)
            Dim detVal = 0
            Dim sign = 1
            For c = 0 To Size - 1
                m.ColumnIndex = c
                Dim d = m.Det()
                detVal += Me(0, c) * d * sign
                sign = -sign
            Next
            Return detVal
        End Function

        Public Sub Print()
            For r = 0 To Size - 1
                Dim rl = r
                Console.WriteLine(Range(0, Size).Select(Function(c) Me(rl, c)).DelimitWith(", "))
            Next
            Console.WriteLine()
        End Sub
    End Class

    Private Function Solve(matrix As SubMatrix) As Integer()
        Dim det = matrix.Det()
        If det = 0 Then Throw New ArgumentException("The determinant is zero.")

        Dim answer(matrix.Size - 1) As Integer
        For i = 0 To matrix.Size - 1
            matrix.ColumnIndex = i
            answer(i) = matrix.Det() / det
        Next
        Return answer
    End Function

    Public Function SolveCramer(equations As Integer()()) As Integer()
        Dim size = equations.Length
        If equations.Any(Function(eq) eq.Length <> size + 1) Then Throw New ArgumentException($"Each equation must have {size + 1} terms.")
        Dim matrix(size - 1, size - 1) As Integer
        Dim column(size - 1) As Integer
        For r = 0 To size - 1
            column(r) = equations(r)(size)
            For c = 0 To size - 1
                matrix(r, c) = equations(r)(c)
            Next
        Next
        Return Solve(New SubMatrix(matrix, column))
    End Function

    Sub Main()
        Dim equations = {
            ({2, -1, 5, 1, -3}),
            ({3, 2, 2, -6, -32}),
            ({1, 3, 3, -1, -47}),
            ({5, -2, -3, 3, 49})
        }
        Dim solution = SolveCramer(equations)
        Console.WriteLine(solution.DelimitWith(", "))
    End Sub

End Module
