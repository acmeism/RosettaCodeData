Option Explicit On
Option Infer On
Option Strict On

Module Currying
    ' The trivial curry.
    Function Curry(Of T1, TResult)(func As Func(Of T1, TResult)) As Func(Of T1, TResult)
        ' At least satisfy the implicit contract that the result isn't reference-equal to the original function.
        Return Function(a) func(a)
    End Function

    Function Curry(Of T1, T2, TResult)(func As Func(Of T1, T2, TResult)) As Func(Of T1, Func(Of T2, TResult))
        Return Function(a) Function(b) func(a, b)
    End Function

    Function Curry(Of T1, T2, T3, TResult)(func As Func(Of T1, T2, T3, TResult)) As Func(Of T1, Func(Of T2, Func(Of T3, TResult)))
        Return Function(a) Function(b) Function(c) func(a, b, c)
    End Function

    ' And so on.
End Module
