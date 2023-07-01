' FB 1.05.0 Win64

Type MyType
  Public:
    Declare Sub InstanceMethod(s As String)
    Declare Static Sub StaticMethod(s As String)
  Private:
    dummy_ As Integer ' types cannot be empty in FB
End Type

Sub MyType.InstanceMethod(s As String)
  Print s
End Sub

Static Sub MyType.StaticMethod(s As String)
  Print s
End Sub

Dim t As MyType
t.InstanceMethod("Hello world!")
MyType.Staticmethod("Hello static world!")
Print
Print "Press any key to quit the program"
Sleep
