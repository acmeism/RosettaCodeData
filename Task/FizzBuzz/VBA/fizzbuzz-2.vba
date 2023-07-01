Sub FizzBuzz()
    Dim i As Integer
    Dim T(1 To 99) As Variant
    For i = 1 To 99 Step 3
        T(i + 0) = IIf((i + 0) Mod 5 = 0, "Buzz", i)
        T(i + 1) = IIf((i + 1) Mod 5 = 0, "Buzz", i + 1)
        T(i + 2) = IIf((i + 2) Mod 5 = 0, "FizzBuzz", "Fizz")
    Next i
    Debug.Print Join(T, ", ") & ", Buzz"
End Sub
