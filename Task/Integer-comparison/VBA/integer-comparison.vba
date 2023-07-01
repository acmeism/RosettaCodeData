Public Sub integer_comparison()
    first_integer = CInt(InputBox("Give me an integer."))
    second_integer = CInt(InputBox("Give me another integer."))
    Debug.Print IIf(first_integer < second_integer, "first integer is smaller than second integer", "first integer is not smaller than second integer")
    Debug.Print IIf(first_integer = second_integer, "first integer is equal to second integer", "first integer is not equal to second integer")
    Debug.Print IIf(first_integer > second_integer, "first integer is bigger than second integer", "first integer is not bigger than second integer")
End Sub
