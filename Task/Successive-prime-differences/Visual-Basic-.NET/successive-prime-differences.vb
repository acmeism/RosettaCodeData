Imports System.Text

Module Module1

    Function Sieve(limit As Integer) As Integer()
        Dim primes As New List(Of Integer) From {2}
        Dim c(limit + 1) As Boolean REM composite = true
        REM no need to process even numbers > 2
        Dim p = 3
        While True
            Dim p2 = p * p
            If p2 > limit Then
                Exit While
            End If
            For i = p2 To limit Step 2 * p
                c(i) = True
            Next
            Do
                p += 2
            Loop While c(p)
        End While
        For i = 3 To limit Step 2
            If Not c(i) Then
                primes.Add(i)
            End If
        Next
        Return primes.ToArray
    End Function

    Function SuccessivePrimes(primes() As Integer, diffs() As Integer) As List(Of List(Of Integer))
        Dim results As New List(Of List(Of Integer))
        Dim dl = diffs.Length
        Dim i = 0
        While i < primes.Length - dl
            Dim group(dl) As Integer
            group(0) = primes(i)

            Dim j = i
            While j < i + dl
                If primes(j + 1) - primes(j) <> diffs(j - i) Then
                    GoTo outer REM continue the outermost loop
                End If
                group(j - i + 1) = primes(j + 1)

                j += 1
            End While
            results.Add(group.ToList)
outer:
            i += 1
        End While
        Return results
    End Function

    Function CollectionToString(Of T)(c As IEnumerable(Of T)) As String
        Dim builder As New StringBuilder
        builder.Append("[")

        Dim it = c.GetEnumerator()
        If it.MoveNext() Then
            builder.Append(it.Current)
        End If
        While it.MoveNext()
            builder.Append(", ")
            builder.Append(it.Current)
        End While

        builder.Append("]")
        Return builder.ToString
    End Function

    Sub Main()
        Dim primes = Sieve(999999)
        Dim diffsList = {({2}), ({1}), ({2, 2}), ({2, 4}), ({4, 2}), ({6, 4, 2})}
        Console.WriteLine("For primes less than 1,000,000:-")
        Console.WriteLine()
        For Each diffs In diffsList
            Console.WriteLine("  For differences of {0} ->", CollectionToString(diffs))
            Dim sp = SuccessivePrimes(primes, diffs)
            If sp.Count = 0 Then
                Console.WriteLine("    No groups found")
                Continue For
            End If
            Console.WriteLine("    First group   = {0}", CollectionToString(sp(0)))
            Console.WriteLine("    Last group    = {0}", CollectionToString(sp(sp.Count - 1)))
            Console.WriteLine("    Number found  = {0}", sp.Count)
            Console.WriteLine()
        Next
    End Sub

End Module
