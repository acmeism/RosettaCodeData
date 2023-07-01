Class sma
'to be stored in a class module with name "sma"
Private n As Integer 'period
Private arr() As Double 'circular list
Private index As Integer 'pointer into arr
Private oldsma As Double

Public Sub init(size As Integer)
    n = size
    ReDim arr(n - 1)
    index = 0
End Sub

Public Function sma(number As Double) As Double
    sma = oldsma + (-arr(index) + number) / n
    oldsma = sma
    arr(index) = number
    index = (index + 1) Mod n
End Function

Normal module
Public Sub main()
    s = [{1,2,3,4,5,5,4,3,2,1}]
    Dim sma3 As New sma
    Dim sma5 As New sma
    sma3.init 3
    sma5.init 5
    For i = 1 To UBound(s)
        Debug.Print i, Format(sma3.sma(CDbl(s(i))), "0.00000"),
        Debug.Print Format(sma5.sma(CDbl(s(i))), "0.00000")
    Next i
End Sub
