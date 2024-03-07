Type Revolver
    cylinder(0 To 5) As Integer
End Type

Sub rshift(r As Revolver)
    Dim t As Integer = r.cylinder(5)
    For i As Integer = 4 To 0 Step -1
        r.cylinder(i + 1) = r.cylinder(i)
    Next i
    r.cylinder(0) = t
End Sub

Sub unload(r As Revolver)
    For i As Integer = 0 To 5
        r.cylinder(i) = 0
    Next i
End Sub

Sub load(r As Revolver)
    While r.cylinder(0) <> 0
        rshift(r)
    Wend
    r.cylinder(0) = -1
    rshift(r)
End Sub

Sub spin(r As Revolver)
    For i As Integer = 1 To Int(Rnd * 6) + 1
        rshift(r)
    Next i
End Sub

Function fire(r As Revolver) As Integer
    Dim As Integer shot = r.cylinder(0)
    rshift(r)
    Return shot
End Function

Function method(r As Revolver, s As String) As Integer
    unload(r)
    For i As Integer = 1 To Len(s)
        Dim c As String = Mid(s, i, 1)
        If c = "L" Then
            load(r)
        Elseif c = "S" Then
            spin(r)
        Elseif c = "F" Then
            If fire(r) <> 0 Then Return 1
        End If
    Next i
    Return 0
End Function

Function mstring(s As String) As String
    Dim As String l = ""
    For i As Integer = 1 To Len(s)
        Dim As String c = Mid(s, i, 1)
        If c = "L" Then
            l &= "load, "
        Elseif c = "S" Then
            l &= "spin, "
        Elseif c = "F" Then
            l &= "fire, "
        End If
    Next i
    Return Left(l, Len(l) - 2)
End Function

Dim As Revolver rev
Dim As Integer tests = 100000
Dim As String methods(0 To 3) = {"LSLSFSF", "LSLSFF", "LLSFSF", "LLSFF"}

For m As Integer = 0 To 3 'In methods
    Dim sum As Integer = 0
    For t As Integer = 1 To tests
        sum += method(rev, methods(m))
    Next t
    Print mstring(methods(m)), " produces "; sum * 100.0 / tests; "% deaths."
Next m

Sleep
