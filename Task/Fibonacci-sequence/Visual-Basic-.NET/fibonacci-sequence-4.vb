Imports System
Imports System.Collections.Generic
Imports BI = System.Numerics.BigInteger

Module Module1

    ' A sparse array of values calculated along the way
    Dim sl As SortedList(Of Integer, BI) = New SortedList(Of Integer, BI)()

    ' Square a BigInteger
    Function sqr(ByVal n As BI) As BI
        Return n * n
    End Function

    ' Helper routine for Fsl(). It adds an entry to the sorted list when necessary
    Sub IfNec(n As Integer)
        If Not sl.ContainsKey(n) Then sl.Add(n, Fsl(n))
    End Sub

    ' This routine is semi-recursive, but doesn't need to evaluate every number up to n.
    ' Algorithm from here: http://www.maths.surrey.ac.uk/hosted-sites/R.Knott/Fibonacci/fibFormula.html#section3
    Function Fsl(ByVal n As Integer) As BI
        If n < 2 Then Return n
        Dim n2 As Integer = n >> 1, pm As Integer = n2 + ((n And 1) << 1) - 1 : IfNec(n2) : IfNec(pm)
        Return If(n2 > pm, (2 * sl(pm) + sl(n2)) * sl(n2), sqr(sl(n2)) + sqr(sl(pm)))
    End Function

    ' Conventional iteration method (not used here)
    Function Fm(ByVal n As BI) As BI
        If n < 2 Then Return n
        Dim cur As BI = 0, pre As BI = 1
        For i As Integer = 0 To n - 1
            Dim sum As BI = cur + pre : pre = cur : cur = sum : Next : Return cur
    End Function

    Sub Main()
        Dim vlen As Integer, num As Integer = 2_000_000, digs As Integer = 35
        Dim sw As System.Diagnostics.Stopwatch = System.Diagnostics.Stopwatch.StartNew()
        Dim v As BI = Fsl(num) : sw.[Stop]()
        Console.Write("{0:n3} ms to calculate the {1:n0}th Fibonacci number, ", sw.Elapsed.TotalMilliseconds, num)
        vlen = CInt(Math.Ceiling(BI.Log10(v))) : Console.WriteLine("number of digits is {0}", vlen)
        If vlen < 10000 Then
            sw.Restart() : Console.WriteLine(v) : sw.[Stop]()
            Console.WriteLine("{0:n3} ms to write it to the console.", sw.Elapsed.TotalMilliseconds)
        Else
            Console.Write("partial: {0}...{1}", v / BI.Pow(10, vlen - digs), v Mod BI.Pow(10, digs))
        End If
    End Sub
End Module
