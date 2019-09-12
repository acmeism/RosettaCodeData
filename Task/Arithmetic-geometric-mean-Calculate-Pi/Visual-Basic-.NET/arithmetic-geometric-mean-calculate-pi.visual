Imports System, System.Numerics

Module Program
    Function IntSqRoot(ByVal valu As BigInteger, ByVal guess As BigInteger) As BigInteger
        Dim term As BigInteger : Do
            term = valu / guess
            If BigInteger.Abs(term - guess) <= 1 Then Exit Do
            guess += term : guess >>= 1
        Loop While True : Return guess
    End Function

    Function ISR(ByVal term As BigInteger, ByVal guess As BigInteger) As BigInteger
        Dim valu As BigInteger = term * guess : Do
            If BigInteger.Abs(term - guess) <= 1 Then Exit Do
            guess += term : guess >>= 1 : term = valu / guess
        Loop While True : Return guess
    End Function

    Function CalcAGM(ByVal lam As BigInteger, ByVal gm As BigInteger, ByRef z As BigInteger,
                     ByVal ep As BigInteger) As BigInteger
        Dim am, zi As BigInteger : Dim n As ULong = 1 : Do
            am = (lam + gm) >> 1 : gm = ISR(lam, gm)
            Dim v As BigInteger = am - lam
            zi = v * v * n : If zi < ep Then Exit Do
            z -= zi : n <<= 1 : lam = am
        Loop While True : Return am
    End Function

    Function BIP(ByVal exp As Integer, ByVal Optional man As ULong = 1) As BigInteger
        Dim rv As BigInteger = BigInteger.Pow(10, exp) : Return If(man = 1, rv, man * rv)
    End Function

    Sub Main(args As String())
        Dim d As Integer = 25000
        If args.Length > 0 Then
            Integer.TryParse(args(0), d)
            If d < 1 OrElse d > 999999 Then d = 25000
        End If
        Dim st As DateTime = DateTime.Now
        Dim am As BigInteger = BIP(d),
            gm As BigInteger = IntSqRoot(BIP(d + d - 1, 5),
                                         BIP(d - 15, Math.Sqrt(0.5) * 1.0E+15)),
             z As BigInteger = BIP(d + d - 2, 25),
             agm As BigInteger = CalcAGM(am, gm, z, BIP(d + 1)),
             pi As BigInteger = agm * agm * BIP(d - 2) / z
        Console.WriteLine("Computation time: {0:0.0000} seconds ",
                          (DateTime.Now - st).TotalMilliseconds / 1000)
        If args.Length > 1 OrElse d <= 1000 Then
            Dim s As String = pi.ToString()
            Console.WriteLine("{0}.{1}", s(0), s.Substring(1))
        End If
        If Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub
End Module
