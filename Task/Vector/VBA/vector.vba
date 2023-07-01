Type vector
    x As Double
    y As Double
End Type
Type vector2
    phi As Double
    r As Double
End Type
Private Function vector_addition(u As vector, v As vector) As vector
    vector_addition.x = u.x + v.x
    vector_addition.y = u.y + v.y
End Function
Private Function vector_subtraction(u As vector, v As vector) As vector
    vector_subtraction.x = u.x - v.x
    vector_subtraction.y = u.y - v.y
End Function
Private Function scalar_multiplication(u As vector, v As Double) As vector
    scalar_multiplication.x = u.x * v
    scalar_multiplication.y = u.y * v
End Function
Private Function scalar_division(u As vector, v As Double) As vector
    scalar_division.x = u.x / v
    scalar_division.y = u.y / v
End Function
Private Function to_cart(v2 As vector2) As vector
    to_cart.x = v2.r * Cos(v2.phi)
    to_cart.y = v2.r * Sin(v2.phi)
End Function
Private Sub display(u As vector)
    Debug.Print "( " & Format(u.x, "0.000") & "; " & Format(u.y, "0.000") & ")";
End Sub
Public Sub main()
    Dim a As vector, b As vector, c As vector2, d As Double
    c.phi = WorksheetFunction.Pi() / 3
    c.r = 5
    d = 10
    a = to_cart(c)
    b.x = 1: b.y = -2
    Debug.Print "addition             : ";: display a: Debug.Print "+";: display b
    Debug.Print "=";: display vector_addition(a, b): Debug.Print
    Debug.Print "subtraction          : ";: display a: Debug.Print "-";: display b
    Debug.Print "=";: display vector_subtraction(a, b): Debug.Print
    Debug.Print "scalar multiplication: ";: display a: Debug.Print " *";: Debug.Print d;
    Debug.Print "=";: display scalar_multiplication(a, d): Debug.Print
    Debug.Print "scalar division      : ";: display a: Debug.Print " /";: Debug.Print d;
    Debug.Print "=";: display scalar_division(a, d)
End Sub
