Imports System.Math, System.Console, BI = System.Numerics.BigInteger

Module Module1

    Sub Main(ByVal args As String())
        Dim i, j, k, d As BI : i = 2
        ' How is using a built-in square root function (Sqrt()) the same as calculating the square root of a decimal digit by hand?
        j = CType(Floor(Sqrt(CDbl(i))), BI) : k = j : d = j
        Dim n As Integer = -1, n0 As Integer = -1,
            st As DateTime = DateTime.Now
        If args.Length > 0 Then Integer.TryParse(args(0), n)
        If n > 0 Then n0 = n Else n = 1
        Do
            Write(d) : i = (i - k * d) * 100 : k = 20 * j
            For d = 1 To 10
                If (k + d) * d > i Then d -= 1 : Exit For
            Next
            j = j * 10 + d : k += d : If n0 > 0 Then n = n - 1
        Loop While n > 0
        If n0 > 0 Then WriteLine (VbLf & "Time taken for {0} digits: {1}", n0, DateTime.Now - st)
    End Sub
End Module
