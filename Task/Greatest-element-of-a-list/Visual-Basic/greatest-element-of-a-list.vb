Public Function ListMax(anArray())
    'return the greatest element in array anArray
    'use LBound and UBound to find its length
    n0 = LBound(anArray)
    n = UBound(anArray)
    theMax = anArray(n0)
    For i = (n0 + 1) To n
        If anArray(i) > theMax Then theMax = anArray(i)
    Next
    ListMax = theMax
End Function


Public Sub ListMaxTest()
    Dim b()
    'test function ListMax
    'fill array b with some numbers:
    b = Array(5992424433449#, 4534344439984#, 551344678, 99800000#)
    'print the greatest element
    Debug.Print "Greatest element is"; ListMax(b())
End Sub
