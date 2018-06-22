Option Explicit

Sub Main_Pick_Random_Element()
    Debug.Print Pick_Random_Element(Array(1, 2, 3, 4, 5, #11/24/2017#, "azerty"))
End Sub

Function Pick_Random_Element(myArray)
    Randomize Timer
    Pick_Random_Element = myArray(Int((Rnd * (UBound(myArray) - LBound(myArray) + 1) + LBound(myArray))))
End Function
