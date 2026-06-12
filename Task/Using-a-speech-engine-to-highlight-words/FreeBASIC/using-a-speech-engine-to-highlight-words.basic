''This works on Windows. Does anyone know how it would be done in Linux?

Sub Speak(Texto As String)
    Shell "mshta vbscript:Execute(""CreateObject(""""SAPI.SpVoice"""").Speak("""""+Texto+""""")(window.close)"")"
End Sub

Function Split(Texto As String, SplitL As String, Direcc As Byte = 0) As String
    Dim As Integer LocA = Instr(Texto, SplitL)
    Return Iif(Direcc <= 0, Left(Texto, LocA), Right(Texto, Len(Texto) - LocA))
End Function

Dim As String texto = "Actions speak louder than words"
Dim As String palabra()
Dim As Integer cont = -1
Do
    cont += 1
    Redim Preserve palabra(cont)
    palabra(cont) = Split(texto," ")
    texto = Right(texto, Len(texto)-Len(palabra(cont)))
    If Len(palabra(cont)) = 0 Then palabra(cont) = texto : Exit Do
Loop

For n As Integer = 0 To Ubound(palabra)
    Print palabra(n)
    Speak palabra(n)
Next n
