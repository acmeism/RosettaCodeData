Function Foo3()
    Foo3 = CalculateValue()
    If Not MoreWorkNeeded() Then Exit Function
    Foo3 = CalculateAnotherValue()
End Function

Function Foo4()
    Dim result = CalculateValue()
    If Not MoreWorkNeeded() Then Return result
    Return CalculateAnotherValue()
End Function
