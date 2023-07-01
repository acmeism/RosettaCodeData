Imports System.Reflection

Module Module1

    Class TestClass
        Private privateField = 7
        Public ReadOnly Property PublicNumber = 4
        Private ReadOnly Property PrivateNumber = 2
    End Class

    Function GetPropertyValues(Of T)(obj As T, flags As BindingFlags) As IEnumerable
        Return From p In obj.GetType().GetProperties(flags)
               Where p.GetIndexParameters().Length = 0
               Select New With {p.Name, Key .Value = p.GetValue(obj, Nothing)}
    End Function

    Function GetFieldValues(Of T)(obj As T, flags As BindingFlags) As IEnumerable
        Return obj.GetType().GetFields(flags).Select(Function(f) New With {f.Name, Key .Value = f.GetValue(obj)})
    End Function

    Sub Main()
        Dim t As New TestClass()
        Dim flags = BindingFlags.Public Or BindingFlags.NonPublic Or BindingFlags.Instance
        For Each prop In GetPropertyValues(t, flags)
            Console.WriteLine(prop)
        Next
        For Each field In GetFieldValues(t, flags)
            Console.WriteLine(field)
        Next
    End Sub

End Module
