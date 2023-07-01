Module Module1
    Dim primes As List(Of Long) = {3L, 5L}.ToList()

    Sub Main(args As String())
        Const cutOff As Integer = 200, bigUn As Integer = 100000,
              tn As String = " cuban prime"
        Console.WriteLine("The first {0:n0}{1}s:", cutOff, tn)
        Dim c As Integer = 0, showEach As Boolean = True, skip As Boolean = True,
            v As Long = 0, st As DateTime = DateTime.Now
        For i As Long = 1 To Long.MaxValue
            v = 3 * i : v = v * i + v + 1
            Dim found As Boolean = False, mx As Integer = Math.Ceiling(Math.Sqrt(v))
            For Each item In primes
                If item > mx Then Exit For
                If v Mod item = 0 Then found = True : Exit For
            Next : If Not found Then
                c += 1 : If showEach Then
                    For z = primes.Last + 2 To v - 2 Step 2
                        Dim fnd As Boolean = False
                        For Each item In primes
                            If item > mx Then Exit For
                            If z Mod item = 0 Then fnd = True : Exit For
                        Next : If Not fnd Then primes.Add(z)
                    Next : primes.Add(v) : Console.Write("{0,11:n0}", v)
                    If c Mod 10 = 0 Then Console.WriteLine()
                    If c = cutOff Then showEach = False
                Else
                    If skip Then skip = False : i += 772279 : c = bigUn - 1
                End If
                If c = bigUn Then Exit For
            End If
        Next
        Console.WriteLine("{1}The {2:n0}th{3} is {0,17:n0}", v, vbLf, c, tn)
        Console.WriteLine("Computation time was {0} seconds", (DateTime.Now - st).TotalSeconds)
        If System.Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub
End Module
