' Delegate declaration is similar to C#.
Delegate Function Func2(a As Integer, b As Integer) As Integer

Module Program
    Function Add(a As Integer, b As Integer) As Integer
        Return a + b
    End Function

    Function Mul(a As Integer, b As Integer) As Integer
        Return a * b
    End Function

    Function Div(a As Integer, b As Integer) As Integer
        Return a \ b
    End Function

    ' Call is a keyword and must be escaped using brackets.
    Function [Call](f As Func2, a As Integer, b As Integer) As Integer
        Return f(a, b)
    End Function

    Sub Main()
        Dim a = 6
        Dim b = 2

        ' Delegates in VB.NET could be created without a New expression from the start. Both syntaxes are shown here.
        Dim add As Func2 = New Func2(AddressOf Program.Add)

        ' The "As New" idiom applies to delegate creation.
        Dim div As New Func2(AddressOf Program.Div)

        ' Directly coercing the AddressOf expression:
        Dim mul As Func2 = AddressOf Program.Mul

        Console.WriteLine("f=Add, f({0}, {1}) = {2}", a, b, [Call](add, a, b))
        Console.WriteLine("f=Mul, f({0}, {1}) = {2}", a, b, [Call](mul, a, b))
        Console.WriteLine("f=Div, f({0}, {1}) = {2}", a, b, [Call](div, a, b))
    End Sub
End Module
