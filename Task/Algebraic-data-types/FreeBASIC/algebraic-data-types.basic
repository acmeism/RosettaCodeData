Const NULL As Any Ptr = 0

Type Arbol
    isRed As Boolean
    valor As Integer
    izda As Arbol Ptr
    dcha As Arbol Ptr
End Type

Dim Shared As Arbol Ptr E

Function crearArbol(c As Boolean, l As Arbol Ptr, v As Integer, r As Arbol Ptr) As Arbol Ptr
    Dim As Arbol Ptr nuevoArbol = Callocate(Sizeof(Arbol))
    nuevoArbol->isRed = c
    nuevoArbol->valor = v
    nuevoArbol->izda = Iif(l <> NULL, l, E)
    nuevoArbol->dcha = Iif(r <> NULL, r, E)
    Return nuevoArbol
End Function

Sub inicializarE()
    E = crearArbol(False, NULL, 0, NULL)
    E->izda = E
    E->dcha = E
End Sub

Function hacerNegro(t As Arbol Ptr) As Arbol Ptr
    t->isRed = False
    Return t
End Function

Function balance(t As Arbol Ptr) As Arbol Ptr
    If t->isRed = False Then
        If t->izda->isRed And t->izda->izda->isRed Then
            Return crearArbol(True, crearArbol(False, t->izda->izda->izda, _
            t->izda->izda->valor, t->izda->izda->dcha), t->izda->valor, _
            crearArbol(False, t->izda->dcha, t->valor, t->dcha))
        Elseif t->izda->isRed And t->izda->dcha->isRed Then
            Return crearArbol(True, crearArbol(False, t->izda->izda, _
            t->izda->valor, t->izda->dcha->izda), t->izda->dcha->valor, _
            crearArbol(False, t->izda->dcha->dcha, t->valor, t->dcha))
        Elseif t->dcha->isRed And t->dcha->izda->isRed Then
            Return crearArbol(True, crearArbol(False, t->izda, t->valor, t->dcha->izda->izda), _
            t->dcha->izda->valor, _
            crearArbol(False, t->dcha->izda->dcha, t->dcha->valor, t->dcha->dcha))
        Elseif t->dcha->isRed And t->dcha->dcha->isRed Then
            Return crearArbol(True, crearArbol(False, t->izda, t->valor, _
            t->dcha->izda), t->dcha->valor, _
            crearArbol(False, t->dcha->dcha->izda, t->dcha->dcha->valor, t->dcha->dcha->dcha))
        End If
    End If
    Return t
End Function

Function ins(t As Arbol Ptr, x As Integer) As Arbol Ptr
    If t = E Then
        Return crearArbol(True, E, x, E)
    Elseif x < t->valor Then
        Return balance(crearArbol(t->isRed, ins(t->izda, x), t->valor, t->dcha))
    Elseif x > t->valor Then
        Return balance(crearArbol(t->isRed, t->izda, t->valor, ins(t->dcha, x)))
    Else
        Return t
    End If
End Function

Function insertar(t As Arbol Ptr, x As Integer) As Arbol Ptr
    Return hacerNegro(ins(t, x))
End Function

Sub imprimeArbol(t As Arbol Ptr, indent As Integer = 0)
    If t = E Then
        Print Space(indent * 4); "[]"
    Else
        imprimeArbol(t->dcha, indent + 1)
        Print Space(indent * 4); "["; Iif(t->isRed, "R", "B"); t->valor; "]"
        imprimeArbol(t->izda, indent + 1)
    End If
End Sub

' Main program
inicializarE()
Dim As Arbol Ptr tree = E

For i As Integer = 1 To 16
    tree = insertar(tree, i)
Next

imprimeArbol(tree)

Sleep
