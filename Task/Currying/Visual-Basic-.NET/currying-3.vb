Option Explicit On
Option Infer On
Option Strict On

Module CurryingDynamic
    ' Cheat visual basic's syntax by defining a type that can be the receiver of what appears to be a method call.
    ' Needless to say, this is not idiomatic VB.
    Class CurryDelegate
        ReadOnly Property Value As Object
        ReadOnly Property Target As [Delegate]

        Sub New(value As Object)
            Dim curry = TryCast(value, CurryDelegate)
            If curry IsNot Nothing Then
                Me.Value = curry.Value
                Me.Target = curry.Target
            ElseIf TypeOf value Is [Delegate] Then
                Me.Target = DirectCast(value, [Delegate])
            Else
                Me.Value = value
            End If
        End Sub

        ' CurryDelegate could also work as a dynamic n-ary function delegate, if an additional ParamArray argument were to be added.
        Default ReadOnly Property Invoke(arg As Object) As CurryDelegate
            Get
                If Me.Target Is Nothing Then Throw New InvalidOperationException("All curried parameters have already been supplied")

                Return New CurryDelegate(Me.Target.DynamicInvoke({arg}))
            End Get
        End Property

        ' A syntactically natural way to assert that the currying is complete and that the result is of the specified type.
        Function Unwrap(Of T)() As T
            If Me.Target IsNot Nothing Then Throw New InvalidOperationException("Some curried parameters have not yet been supplied.")
            Return DirectCast(Me.Value, T)
        End Function
    End Class

    Function DynamicCurry(func As [Delegate]) As CurryDelegate
        Return DynamicCurry(func, ImmutableList(Of Object).Empty)
    End Function

    ' Use ImmutableList to create a new list every time any curried subfunction is called avoiding multiple or repeated
    ' calls interfering with each other.
    Private Function DynamicCurry(func As [Delegate], collectedArgs As ImmutableList(Of Object)) As CurryDelegate
        Return If(collectedArgs.Count = func.Method.GetParameters().Length,
            New CurryDelegate(func.DynamicInvoke(collectedArgs.ToArray())),
            New CurryDelegate(Function(arg As Object) DynamicCurry(func, collectedArgs.Add(arg))))
    End Function
End Module
