    Imports System.Linq
    Function ValidLuhn(value As String)
        Return value.Select(Function(c, i) (AscW(c) - 48) << ((value.Length - i - 1) And 1)).Sum(Function(n) If(n > 9, n - 9, n)) Mod 10 = 0
    End Function
    Sub Main()
        Console.WriteLine(ValidLuhn("49927398716"))
        Console.WriteLine(ValidLuhn("49927398717"))
        Console.WriteLine(ValidLuhn("1234567812345678"))
        Console.WriteLine(ValidLuhn("1234567812345670"))
    End Sub
