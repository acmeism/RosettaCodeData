Type Method
    Func As Function() As String
End Type

Function DefaultMethod() As String
    Return "no such method"
End Function

Type Objeto
    Methods As Method Ptr
End Type

Sub Invoke(obj As Objeto, methodName As String)
    If methodName = "exists" Then
        Print obj.Methods->Func()
    Else
        Print DefaultMethod()
    End If
End Sub

Function exists() As String
    Return "exists"
End Function

Function CreateObject() As Objeto
    Dim As Objeto obj
    Dim As Method met
    met.Func = @exists
    obj.Methods = @met
    Return obj
End Function

Dim As Objeto o = CreateObject()
Invoke(o, "exists")
Invoke(o, "non_existent_method")

Sleep
