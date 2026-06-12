Print !"\ntrabajando...\n"
Print !"M¡nima potencia de 6 cuya expansi¢n decimal contiene n:\n"

Dim As Uinteger num = 0, limit = 200, m

For n As Ubyte = 0 To 21
    Dim As String strn = Str(n)
    For m = 0 To limit
        Dim As String strpow = Str(6 ^ m)
        Dim As Ulong ind = Instr(strpow,strn)
        If ind > 0 Then
            Print Using "##. 6^\\ = &"; n; Str(m); strpow
            Exit For
        End If
    Next m
Next n

Print !"\n--- terminado, pulsa RETURN---"
Sleep
