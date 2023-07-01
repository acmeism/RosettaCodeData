Module Program
    Dim primes As List(Of Long) = {3L, 5L}.ToList()

    Sub Main(args As String())
        Dim taskList As New List(Of Task(Of Integer))
        Const cutOff As Integer = 200, bigUn As Integer = 100000,
              chunks As Integer = 50, little As Integer = bigUn / chunks,
              tn As String = " cuban prime"
        Console.WriteLine("The first {0:n0}{1}s:", cutOff, tn)
        Dim c As Integer = 0, showEach As Boolean = True,
            u As Long = 0, v As Long = 1,
            st As DateTime = DateTime.Now
        For i As Long = 1 To Long.MaxValue
            u += 6 : v += u
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
                    If c = cutOff Then showEach = False : _
                        Console.Write("{0}Progress to the {1:n0}th{2}: ", vbLf, bigUn, tn)
                End If
                If c Mod little = 0 Then Console.Write(".") : If c = bigUn Then Exit For
            End If
        Next
        Console.WriteLine("{1}The {2:n0}th{3} is {0,17:n0}", v, vbLf, c, tn)
        Console.WriteLine("Computation time was {0} seconds", (DateTime.Now - st).TotalSeconds)
        If System.Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub
End Module
