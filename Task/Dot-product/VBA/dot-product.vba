Private Function dot_product(x As Variant, y As Variant) As Double
    dot_product = WorksheetFunction.SumProduct(x, y)
End Function

Public Sub main()
    Debug.Print dot_product([{1,3,-5}], [{4,-2,-1}])
End Sub
