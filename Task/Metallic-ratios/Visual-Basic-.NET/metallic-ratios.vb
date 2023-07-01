Imports BI = System.Numerics.BigInteger

Module Module1

    Function IntSqRoot(v As BI, res As BI) As BI
        REM res is the initial guess
        Dim term As BI = 0
        Dim d As BI = 0
        Dim dl As BI = 1
        While dl <> d
            term = v / res
            res = (res + term) >> 1
            dl = d
            d = term - res
        End While
        Return term
    End Function

    Function DoOne(b As Integer, digs As Integer) As String
        REM calculates result via square root, not iterations
        Dim s = b * b + 4
        digs += 1
        Dim g As BI = Math.Sqrt(s * Math.Pow(10, digs))
        Dim bs = IntSqRoot(s * BI.Parse("1" + New String("0", digs << 1)), g)
        bs += b * BI.Parse("1" + New String("0", digs))
        bs >>= 1
        bs += 4
        Dim st = bs.ToString
        digs -= 1
        Return String.Format("{0}.{1}", st(0), st.Substring(1, digs))
    End Function

    Function DivIt(a As BI, b As BI, digs As Integer) As String
        REM performs division
        Dim al = a.ToString.Length
        Dim bl = b.ToString.Length
        digs += 1
        a *= BI.Pow(10, digs << 1)
        b *= BI.Pow(10, digs)
        Dim s = (a / b + 5).ToString
        digs -= 1
        Return s(0) + "." + s.Substring(1, digs)
    End Function

    REM custom formatting
    Function Joined(x() As BI) As String
        Dim wids() = {1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}
        Dim res = ""
        For i = 0 To x.Length - 1
            res += String.Format("{0," + (-wids(i)).ToString + "} ", x(i))
        Next
        Return res
    End Function

    Sub Main()
        REM calculates and checks each "metal"
        Console.WriteLine("Metal B Sq.Rt Iters /---- 32 decimal place value ----\\  Matches Sq.Rt Calc")
        Dim t = ""
        Dim n As BI
        Dim nm1 As BI
        Dim k As Integer
        Dim j As Integer
        For b = 0 To 9
            Dim lst(14) As BI
            lst(0) = 1
            lst(1) = 1
            For i = 2 To 14
                lst(i) = b * lst(i - 1) + lst(i - 2)
            Next
            REM since all the iterations (except Pt) are > 15, continue iterating from the end of the list of 15
            n = lst(14)
            nm1 = lst(13)
            k = 0
            j = 13
            While k = 0
                Dim lt = t
                t = DivIt(n, nm1, 32)
                If lt = t Then
                    k = If(b = 0, 1, j)
                End If
                Dim onn = n
                n = b * n + nm1
                nm1 = onn

                j += 1
            End While
            Console.WriteLine("{0,4}  {1}   {2,2}    {3, 2}  {4}  {5}" + vbNewLine + "{6,19} {7}", "Pt Au Ag CuSn Cu Ni Al Fe Sn Pb".Split(" ")(b), b, b * b + 4, k, t, t = DoOne(b, 32), "", Joined(lst))
        Next
        REM now calculate and check big one
        n = 1
        nm1 = 1
        k = 0
        j = 1
        While k = 0
            Dim lt = t
            t = DivIt(n, nm1, 256)
            If lt = t Then
                k = j
            End If
            Dim onn = n
            n += nm1
            nm1 = onn

            j += 1
        End While
        Console.WriteLine()
        Console.WriteLine("Au to 256 digits:")
        Console.WriteLine(t)
        Console.WriteLine("Iteration count: {0}  Matched Sq.Rt Calc: {1}", k, t = DoOne(1, 256))
    End Sub

End Module
