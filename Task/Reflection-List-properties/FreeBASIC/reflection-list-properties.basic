Type TestClass
    Private:
        PrivateField As Integer = 7
        PrivateNumber As Integer = 2
    Public:
        PublicNumber As Integer = 4
        Declare Function GetPrivateField() As Integer
        Declare Function GetPrivateNumber() As Integer
End Type

Function TestClass.GetPrivateField() As Integer
    Return PrivateField
End Function

Function TestClass.GetPrivateNumber() As Integer
    Return PrivateNumber
End Function

Sub GetPropertyValues(Byval obj As TestClass Ptr)
    Print "PublicNumber: " & obj->PublicNumber
End Sub

Sub GetFieldValues(Byval obj As TestClass Ptr)
    Print "PrivateField: " & obj->GetPrivateField()
    Print "PrivateNumber: " & obj->GetPrivateNumber()
End Sub

Dim As TestClass t
GetPropertyValues(@t)
GetFieldValues(@t)

Sleep
