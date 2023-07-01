Imports System, System.Numerics, System.Text

Module Module1

    Sub RunPiF(ByVal msg As String)
        If msg.Length > 0 Then Console.WriteLine(msg)
        Dim first As Boolean = True, stp As Integer = 360,
            res As StringBuilder = New StringBuilder(),
            rc As Integer = -1, y As Byte, et As TimeSpan,
            st As DateTime = DateTime.Now,
            q, r, t, g, j, h, k, a, b As BigInteger
            q = 1 : r = 180 : t = 60 : g = 60 : j = 54
            h = 10 : k = 10 : a = 15 : b = 3
        While True ' use this to stop after a keypress
        ' While rc < 20000 ' use this to stop after some fixed point
            While res.Length < stp
                a += 27 : y = CByte((q * a + 5 * r) / (5 * t))
                res.Append(y) : b += 5 : j += 54 : g += j
                r = 10 * g * (q * b + r - y * t)
                k += 40 : h += k : q *= h : t *= g
            End While
            If first Then res.Insert(1, "."c) : first = False
            Console.Write(res.ToString())
            rc += res.Length : res.Clear()
            If Console.KeyAvailable Then Exit While
        End While
        et = DateTime.Now - st : Console.ReadKey()
        Console.Write(res.ToString()) : rc += res.Length
        Console.WriteLine(vbLf & "Produced {0} digits in {1:n4} seconds.", rc, et.TotalSeconds)
    End Sub

    Sub Main(args As String())
        RunPiF("Press a key to exit...")
        If Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub
End Module
