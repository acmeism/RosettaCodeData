Option Strict On

Imports Matrix = System.Collections.Generic.List(Of System.Collections.Generic.List(Of Integer))

Module Module1

    Sub Swap(Of T)(ByRef a As T, ByRef b As T)
        Dim u = a
        a = b
        b = u
    End Sub

    Sub PrintSquare(latin As Matrix)
        For Each row In latin
            Dim it = row.GetEnumerator
            Console.Write("[")
            If it.MoveNext Then
                Console.Write(it.Current)
            End If
            While it.MoveNext
                Console.Write(", ")
                Console.Write(it.Current)
            End While
            Console.WriteLine("]")
        Next
        Console.WriteLine()
    End Sub

    Function DList(n As Integer, start As Integer) As Matrix
        start -= 1 REM use 0 based indexes
        Dim a = Enumerable.Range(0, n).ToArray
        a(start) = a(0)
        a(0) = start
        Array.Sort(a, 1, a.Length - 1)
        Dim first = a(1)
        REM recursive closure permutes a[1:]
        Dim r As New Matrix

        Dim Recurse As Action(Of Integer) = Sub(last As Integer)
                                                If last = first Then
                                                    REM bottom of recursion. you get here once for each permutation
                                                    REM test if permutation is deranged.
                                                    For j = 1 To a.Length - 1
                                                        Dim v = a(j)
                                                        If j = v Then
                                                            Return REM no, ignore it
                                                        End If
                                                    Next
                                                    REM yes, save a copy with 1 based indexing
                                                    Dim b = a.Select(Function(v) v + 1).ToArray
                                                    r.Add(b.ToList)
                                                    Return
                                                End If
                                                For i = last To 1 Step -1
                                                    Swap(a(i), a(last))
                                                    Recurse(last - 1)
                                                    Swap(a(i), a(last))
                                                Next
                                            End Sub
        Recurse(n - 1)
        Return r
    End Function

    Function ReducedLatinSquares(n As Integer, echo As Boolean) As ULong
        If n <= 0 Then
            If echo Then
                Console.WriteLine("[]")
                Console.WriteLine()
            End If
            Return 0
        End If
        If n = 1 Then
            If echo Then
                Console.WriteLine("[1]")
                Console.WriteLine()
            End If
            Return 1
        End If

        Dim rlatin As New Matrix
        For i = 0 To n - 1
            rlatin.Add(New List(Of Integer))
            For j = 0 To n - 1
                rlatin(i).Add(0)
            Next
        Next
        REM first row
        For j = 0 To n - 1
            rlatin(0)(j) = j + 1
        Next

        Dim count As ULong = 0
        Dim Recurse As Action(Of Integer) = Sub(i As Integer)
                                                Dim rows = DList(n, i)

                                                For r = 0 To rows.Count - 1
                                                    rlatin(i - 1) = rows(r)
                                                    For k = 0 To i - 2
                                                        For j = 1 To n - 1
                                                            If rlatin(k)(j) = rlatin(i - 1)(j) Then
                                                                If r < rows.Count - 1 Then
                                                                    GoTo outer
                                                                End If
                                                                If i > 2 Then
                                                                    Return
                                                                End If
                                                            End If
                                                        Next
                                                    Next
                                                    If i < n Then
                                                        Recurse(i + 1)
                                                    Else
                                                        count += 1UL
                                                        If echo Then
                                                            PrintSquare(rlatin)
                                                        End If
                                                    End If
outer:
                                                    While False
                                                        REM empty
                                                    End While
                                                Next
                                            End Sub

        REM remiain rows
        Recurse(2)
        Return count
    End Function

    Function Factorial(n As ULong) As ULong
        If n <= 0 Then
            Return 1
        End If
        Dim prod = 1UL
        For i = 2UL To n
            prod *= i
        Next
        Return prod
    End Function

    Sub Main()
        Console.WriteLine("The four reduced latin squares of order 4 are:")
        Console.WriteLine()
        ReducedLatinSquares(4, True)

        Console.WriteLine("The size of the set of reduced latin squares for the following orders")
        Console.WriteLine("and hence the total number of latin squares of these orders are:")
        Console.WriteLine()
        For n = 1 To 6
            Dim nu As ULong = CULng(n)

            Dim size = ReducedLatinSquares(n, False)
            Dim f = Factorial(nu - 1UL)
            f *= f * nu * size
            Console.WriteLine("Order {0}: Size {1} x {2}! x {3}! => Total {4}", n, size, n, n - 1, f)
        Next
    End Sub

End Module
