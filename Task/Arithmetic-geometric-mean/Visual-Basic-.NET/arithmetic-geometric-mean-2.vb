Imports System.Math
Imports System.Console
Imports BI = System.Numerics.BigInteger

Module Module1

    Function BIP(ByVal leadDig As Char, ByVal numDigs As Integer) As BI
        BIP = BI.Parse(leadDig & New String("0"c, numDigs))
    End Function

    Function IntSqRoot(ByVal v As BI, ByVal res As BI) As BI ' res is the initial guess of the square root
        Dim d As BI = 0, dl As BI = 1
        While dl <> d :  IntSqRoot = v / res : res = (res + IntSqRoot) / 2
            dl = d : d = IntSqRoot - res : End While
    End Function

    Function CalcByAGM(ByVal digits As Integer) As BI
        Dim a As BI = BIP("1"c, digits), ' value is 1, extended to required number of digits
            c as BI, ' a temporary variable for swapping a and b
            diff As BI = 0, ldiff As BI = 1 ' difference of a and b, last difference
        CalcByAGM = BI.Parse(String.Format("{0:0.00000000000000000}", ' initial value of square root of 0.5
            Sqrt(0.5)).Substring(2) & New String("0"c, digits - 17))
        CalcByAGM = IntSqRoot(BIP("5"c, (digits << 1) - 1), CalcByAGM) ' value is now the square root of 0.5
        While ldiff <> diff : c = a : a = (a + CalcByAGM) >> 1 : CalcByAGM = IntSqRoot(c * CalcByAGM, a)
            ldiff = diff : diff = a - CalcByAGM : End While
    End Function

    Sub Main(ByVal args As String())
        Dim digits As Integer = 25000
        If args.Length > 0 Then Integer.TryParse(args(0), digits) : _
            If digits < 1 OrElse digits > 999999 Then digits = 25000
        WriteLine("0.{0}", CalcByAGM(digits))
        If System.Diagnostics.Debugger.IsAttached Then ReadKey()
    End Sub

End Module
