Option Base 1
Function dot_product(a As Variant, b As Variant) As Variant
    dot_product = WorksheetFunction.SumProduct(a, b)
End Function

Function cross_product(a As Variant, b As Variant) As Variant
    cross_product = Array(a(2) * b(3) - a(3) * b(2), a(3) * b(1) - a(1) * b(3), a(1) * b(2) - a(2) * b(1))
End Function

Function scalar_triple_product(a As Variant, b As Variant, c As Variant) As Variant
    scalar_triple_product = dot_product(a, cross_product(b, c))
End Function

Function vector_triple_product(a As Variant, b As Variant, c As Variant) As Variant
    vector_triple_product = cross_product(a, cross_product(b, c))
End Function

Public Sub main()
    a = [{3, 4, 5}]
    b = [{4, 3, 5}]
    c = [{-5, -12, -13}]
    Debug.Print "      a . b = "; dot_product(a, b)
    Debug.Print "      a x b = "; "("; Join(cross_product(a, b), ", "); ")"
    Debug.Print "a . (b x c) = "; scalar_triple_product(a, b, c)
    Debug.Print "a x (b x c) = "; "("; Join(vector_triple_product(a, b, c), ", "); ")"
End Sub
