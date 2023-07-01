Imports System.Console
Imports BI = System.Numerics.BigInteger

Module Module1

    Dim Implems() As String = {"Built-In", "Recursive", "Iterative"},
        powers() As Integer = {5, 4, 3, 2}

    Function intPowR(val As BI, exp As BI) As BI
        If exp = 0 Then Return 1
        Dim ne As BI, vs As BI = val * val
        If exp.IsEven Then ne = exp >> 1 : Return If (ne > 1, intPowR(vs, ne), vs)
        ne = (exp - 1) >> 1 : Return If (ne > 1, intPowR(vs, ne), vs) * val
    End Function

    Function intPowI(val As BI, exp As BI) As BI
        intPowI = 1 : While (exp > 0) : If Not exp.IsEven Then intPowI *= val
            val *= val : exp >>= 1 : End While
    End Function

    Sub DoOne(title As String, p() As Integer)
        Dim st As DateTime = DateTime.Now, res As BI, resStr As String
        Select Case (Array.IndexOf(Implems, title))
            Case 0 : res = BI.Pow(p(0), CInt(BI.Pow(p(1), CInt(BI.Pow(p(2), p(3))))))
            Case 1 : res = intPowR(p(0), intPowR(p(1), intPowR(p(2), p(3))))
            Case Else : res = intPowI(p(0), intPowI(p(1), intPowI(p(2), p(3))))
        End Select : resStr = res.ToString()
        Dim et As TimeSpan = DateTime.Now - st
        Debug.Assert(resStr.Length = 183231)
        Debug.Assert(resStr.StartsWith("62060698786608744707"))
        Debug.Assert(resStr.EndsWith("92256259918212890625"))
        WriteLine("n = {0}", String.Join("^", powers))
        WriteLine("n = {0}...{1}", resStr.Substring(0, 20),  resStr.Substring(resStr.Length - 20, 20))
        WriteLine("n digits = {0}", resStr.Length)
        WriteLine("{0} elasped: {1} milliseconds." & vblf, title, et.TotalMilliseconds)
    End Sub

    Sub Main()
        For Each itm As String in Implems : DoOne(itm, powers) : Next
        If Debugger.IsAttached Then Console.ReadKey()
    End Sub

End Module
