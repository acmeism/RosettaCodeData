Sub Main()
Dim List
    Debug.Print IsEqualOrAscending(Array("AA", "BB", "CC"))
    Debug.Print IsEqualOrAscending(Array("AA", "AA", "AA"))
    Debug.Print IsEqualOrAscending(Array("AA", "CC", "BB"))
    Debug.Print IsEqualOrAscending(Array("AA", "ACB", "BB", "CC"))
    Debug.Print IsEqualOrAscending(Array("single_element"))
    Debug.Print IsEqualOrAscending(Array("AA", "BB", "BB"))
    'test with Empty Array :
    Debug.Print IsEqualOrAscending(List)
End Sub
