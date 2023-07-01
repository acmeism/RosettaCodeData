Option Strict On
Option Explicit On

Imports System.IO

''' <summary>Find solutions to the "Prime Triangle" - a triangle of numbers that sum to primes.</summary>
Module vMain

    Public Const maxNumber As Integer = 20 ' Largest number we will consider.
    Dim prime(2 * maxNumber) As Boolean    ' prime sieve.

    ''' <returns>The number of possible arrangements of the integers for a row in the prime triangle.</returns>
    Public Function countArrangements(ByVal n As Integer) As Integer
        If n < 2 Then ' No solutions for n < 2.
            Return 0
        ElseIf n < 4 Then
            ' For 2 and 3. there is only 1 solution: 1, 2 and 1, 2, 3.
            For i As Integer = 1 To n
                Console.Out.Write(i.ToString.PadLeft(3))
            Next i
            Console.Out.WriteLine()
            Return 1
        Else
            ' 4 or more - must find the solutions.
            Dim printSolution As Boolean = true
            Dim used(n) As Boolean
            Dim number(n) As Integer
            ' The triangle row must have 1 in the leftmost and n in the rightmost elements.
            ' The numbers must alternate between even and odd in order for the sums to be prime.
            For i As Integer = 0 To n - 1
                number(i) = i Mod 2
            Next i
            used(1) = True
            number(n) = n
            used(n) = True
            ' Find the intervening numbers and count the solutions.
            Dim count As Integer = 0
            Dim p As Integer = 2
            Do While p > 0
                Dim p1 As Integer = number(p - 1)
                Dim current As Integer = number(p)
                Dim [next] As Integer = current + 2
                Do While [next] < n AndAlso (Not prime(p1 + [next]) Or used([next]))
                    [next] += 2
                Loop
                If [next] >= n Then
                    [next] = 0
                End If
                If p = n - 1 Then
                    ' We are at the final number before n.
                    ' It must be the final even/odd number preceded by the final odd/even number.
                    If [next] <> 0 Then
                        ' Possible solution.
                        If prime([next] + n) Then
                            ' Found a solution.
                            count += 1
                            If printSolution Then
                                For i As Integer = 1 To n - 2
                                     Console.Out.Write(number(i).ToString.PadLeft(3))
                                Next i
                                Console.Out.WriteLine([next].ToString.PadLeft(3) & n.ToString.PadLeft(3))
                                printSolution = False
                            End If
                        End If
                        [next] = 0
                    End If
                    ' Backtrack for more solutions.
                    p -= 1
                    ' There will be a further backtrack as next is 0 ( there could only be one possible number at p - 1 ).
                End If
                If [next] <> 0 Then
                    ' have a/another number that can appear at p.
                    used(current) = False
                    used([next]) = True
                    number(p) = [next]
                    ' Haven't found all the intervening digits yet.
                    p += 1
                ElseIf p <= 2 Then
                    ' No more solutions.
                    p = 0
                Else
                    ' Can't find a number for this position, backtrack.
                    used(number(p)) = False
                    number(p) = p Mod 2
                    p -= 1
                End If
            Loop
            Return count
        End If
    End Function

    Public Sub Main
        prime(2) = True
        For i As Integer = 3 To UBound(prime) Step  2
            prime(i) = True
        Next i
        For i As Integer = 3 To Convert.ToInt32(Math.Floor(Math.Sqrt(Ubound(prime)))) Step 2
            If prime(i) Then
                For s As Integer = i * i To Ubound(prime) Step i + i
                    prime(s) = False
                Next s
            End If
        Next i

        Dim  arrangements(maxNumber) As Integer
        For n As Integer = 2 To UBound(arrangements)
            arrangements(n) = countArrangements(n)
        Next n
        For n As Integer = 2 To UBound(arrangements)
            Console.Out.Write(" " & arrangements(n))
        Next n
        Console.Out.WriteLine()

    End Sub

End Module
