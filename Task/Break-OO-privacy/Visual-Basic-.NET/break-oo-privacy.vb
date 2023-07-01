Imports System.Reflection

' MyClass is a VB keyword.
Public Class MyClazz
    Private answer As Integer = 42
End Class

Public Class Program
    Public Shared Sub Main()
        Dim myInstance = New MyClazz()
        Dim fieldInfo = GetType(MyClazz).GetField("answer", BindingFlags.NonPublic Or BindingFlags.Instance)
        Dim answer = fieldInfo.GetValue(myInstance)
        Console.WriteLine(answer)
    End Sub
End Class
