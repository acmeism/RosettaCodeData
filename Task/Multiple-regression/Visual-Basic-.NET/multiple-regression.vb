Module Module1

    Sub Swap(Of T)(ByRef x As T, ByRef y As T)
        Dim temp = x
        x = y
        y = temp
    End Sub

    Sub Require(condition As Boolean, message As String)
        If condition Then
            Return
        End If
        Throw New ArgumentException(message)
    End Sub

    Class Matrix
        Private data As Double(,)
        Private rowCount As Integer
        Private colCount As Integer

        Public Sub New(rows As Integer, cols As Integer)
            Require(rows > 0, "Need at least one row")
            rowCount = rows

            Require(cols > 0, "Need at least one column")
            colCount = cols

            data = New Double(rows - 1, cols - 1) {}
        End Sub

        Public Sub New(source As Double(,))
            Dim rows = source.GetLength(0)
            Require(rows > 0, "Need at least one row")
            rowCount = rows

            Dim cols = source.GetLength(1)
            Require(cols > 0, "Need at least one column")
            colCount = cols

            data = New Double(rows - 1, cols - 1) {}
            For i = 1 To rows
                For j = 1 To cols
                    data(i - 1, j - 1) = source(i - 1, j - 1)
                Next
            Next
        End Sub

        Default Public Property Index(i As Integer, j As Integer) As Double
            Get
                Return data(i, j)
            End Get
            Set(value As Double)
                data(i, j) = value
            End Set
        End Property

        Public Property Slice(i As Integer) As Double()
            Get
                Dim m(colCount - 1) As Double
                For j = 1 To colCount
                    m(j - 1) = Index(i, j - 1)
                Next
                Return m
            End Get
            Set(value As Double())
                Require(colCount = value.Length, "Slice must match the number of columns")
                For j = 1 To colCount
                    Index(i, j - 1) = value(j - 1)
                Next
            End Set
        End Property

        Public Shared Operator *(m1 As Matrix, m2 As Matrix) As Matrix
            Dim rc1 = m1.rowCount
            Dim cc1 = m1.colCount
            Dim rc2 = m2.rowCount
            Dim cc2 = m2.colCount
            Require(cc1 = rc2, "Cannot multiply if the first columns does not equal the second rows")
            Dim result As New Matrix(rc1, cc2)
            For i = 1 To rc1
                For j = 1 To cc2
                    For k = 1 To rc2
                        result(i - 1, j - 1) += m1(i - 1, k - 1) * m2(k - 1, j - 1)
                    Next
                Next
            Next
            Return result
        End Operator

        Public Function Transpose() As Matrix
            Dim rc = rowCount
            Dim cc = colCount

            Dim trans As New Matrix(cc, rc)
            For i = 1 To cc
                For j = 1 To rc
                    trans(i - 1, j - 1) = Index(j - 1, i - 1)
                Next
            Next
            Return trans
        End Function

        Public Sub ToReducedRowEchelonForm()
            Dim lead = 0
            Dim rc = rowCount
            Dim cc = colCount
            For r = 1 To rc
                If cc <= lead Then
                    Return
                End If
                Dim i = r

                While Index(i - 1, lead) = 0.0
                    i += 1
                    If rc = i Then
                        i = r
                        lead += 1
                        If cc = lead Then
                            Return
                        End If
                    End If
                End While

                Dim temp = Slice(i - 1)
                Slice(i - 1) = Slice(r - 1)
                Slice(r - 1) = temp

                If Index(r - 1, lead) <> 0.0 Then
                    Dim div = Index(r - 1, lead)
                    For j = 1 To cc
                        Index(r - 1, j - 1) /= div
                    Next
                End If

                For k = 1 To rc
                    If k <> r Then
                        Dim mult = Index(k - 1, lead)
                        For j = 1 To cc
                            Index(k - 1, j - 1) -= Index(r - 1, j - 1) * mult
                        Next
                    End If
                Next

                lead += 1
            Next
        End Sub

        Public Function Inverse() As Matrix
            Require(rowCount = colCount, "Not a square matrix")
            Dim len = rowCount
            Dim aug As New Matrix(len, 2 * len)
            For i = 1 To len
                For j = 1 To len
                    aug(i - 1, j - 1) = Index(i - 1, j - 1)
                Next
                REM augment identity matrix to right
                aug(i - 1, i + len - 1) = 1.0
            Next
            aug.ToReducedRowEchelonForm()
            Dim inv As New Matrix(len, len)
            For i = 1 To len
                For j = len + 1 To 2 * len
                    inv(i - 1, j - len - 1) = aug(i - 1, j - 1)
                Next
            Next
            Return inv
        End Function
    End Class

    Function ConvertArray(source As Double()) As Double(,)
        Dim dest(0, source.Length - 1) As Double
        For i = 1 To source.Length
            dest(0, i - 1) = source(i - 1)
        Next
        Return dest
    End Function

    Function MultipleRegression(y As Double(), x As Matrix) As Double()
        Dim tm As New Matrix(ConvertArray(y))
        Dim cy = tm.Transpose
        Dim cx = x.Transpose
        Return ((x * cx).Inverse * x * cy).Transpose.Slice(0)
    End Function

    Sub Print(v As Double())
        Dim it = v.GetEnumerator()

        Console.Write("[")
        If it.MoveNext() Then
            Console.Write(it.Current)
        End If
        While it.MoveNext
            Console.Write(", ")
            Console.Write(it.Current)
        End While
        Console.Write("]")
    End Sub

    Sub Main()
        Dim y() = {1.0, 2.0, 3.0, 4.0, 5.0}
        Dim x As New Matrix({{2.0, 1.0, 3.0, 4.0, 5.0}})
        Dim v = MultipleRegression(y, x)
        Print(v)
        Console.WriteLine()

        y = {3.0, 4.0, 5.0}
        x = New Matrix({
            {1.0, 2.0, 1.0},
            {1.0, 1.0, 2.0}
        })
        v = MultipleRegression(y, x)
        Print(v)
        Console.WriteLine()

        y = {52.21, 53.12, 54.48, 55.84, 57.2, 58.57, 59.93, 61.29, 63.11, 64.47, 66.28, 68.1, 69.92, 72.19, 74.46}
        Dim a = {1.47, 1.5, 1.52, 1.55, 1.57, 1.6, 1.63, 1.65, 1.68, 1.7, 1.73, 1.75, 1.78, 1.8, 1.83}

        Dim xs(2, a.Length - 1) As Double
        For i = 1 To a.Length
            xs(0, i - 1) = 1.0
            xs(1, i - 1) = a(i - 1)
            xs(2, i - 1) = a(i - 1) * a(i - 1)
        Next
        x = New Matrix(xs)
        v = MultipleRegression(y, x)
        Print(v)
        Console.WriteLine()
    End Sub

End Module
