Option Explicit

Private mKey As String
Private mValue As Variant

Public Property Get Value() As Variant
    Value = mValue
End Property
Public Property Let Value(iValue As Variant)
    mValue = iValue
End Property
Public Property Get Key() As Variant
    Key = mKey
End Property
Private Property Let Key(iKey As Variant)
    mKey = iKey
End Property

Public Sub Add(K As String, V As Variant)
    Value = V
    Key = K
End Sub
