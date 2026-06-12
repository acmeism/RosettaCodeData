Dim Shared As String permitido(2)
permitido(0) = "zero"
permitido(1) = "one"
permitido(2) = "two"
Dim Shared As Any Ptr instancias(2)

Type multiton
    id As String
    Declare Constructor(id As String)
End Type

Constructor multiton(id As String)
    Dim k As Integer = -1
    For i As Integer = 0 To Ubound(permitido)
        If permitido(i) = id Then
            k = i
            Exit For
        End If
    Next
    If k = -1 Then
        Print "not permitido"
        End 1
    End If
    If instancias(k) = 0 Then
        this.id = id & "_" & Str(Int(Rnd * 999))
        instancias(k) = @This
    Else
        This = *Cast(multiton Ptr, instancias(k))
    End If
End Constructor

Dim a As multiton = multiton("zero")
Dim b As multiton = multiton("one")
Dim c As multiton = multiton("two")
Dim d As multiton = multiton("zero")
' Dim e As multiton = multiton()        ' crashes
' Dim f As multiton = multiton("three") ' crashes
Dim e As multiton = multiton("one")
Dim f As multiton = multiton("two")

Print a.id
Print b.id
Print c.id
Print d.id
Print e.id
Print f.id

Sleep
