Dim As String texts(2)
texts(0) = "The quick brown fox jumped over the lazy dog."
texts(1) = "I was looking at some rhododendrons in my back garden," & Chr(10) & "dressed in my khaki shorts, when the telephone rang." & Chr(10) & Chr(10) & "As I answered it, I cheerfully glimpsed that the July sun" & Chr(10) & "caused a fragment of black pine wax to ooze on the velvet quilt" & Chr(10) & "laying in my patio."
texts(2) = "sphinx of black quartz, judge my vow."

Type Replacement
    oldStr As String
    newStr As String
End Type

Dim Shared As Replacement replacements(51)
replacements(0).oldStr = "ch" : replacements(0).newStr = "χ"
replacements(1).oldStr = "th" : replacements(1).newStr = "θ"
replacements(2).oldStr = "ps" : replacements(2).newStr = "ψ"
replacements(3).oldStr = "ph" : replacements(3).newStr = "f"
replacements(4).oldStr = "Ch" : replacements(4).newStr = "Χ"
replacements(5).oldStr = "Th" : replacements(5).newStr = "Θ"
replacements(6).oldStr = "Ps" : replacements(6).newStr = "Ψ"
replacements(7).oldStr = "Ph" : replacements(7).newStr = "F"
replacements(8).oldStr = "ee" : replacements(8).newStr = "h"
replacements(9).oldStr = "ck" : replacements(9).newStr = "κ"
replacements(10).oldStr = "rh" : replacements(10).newStr = "r"
replacements(11).oldStr = "kh" : replacements(11).newStr = "χ"
replacements(12).oldStr = "Kh" : replacements(12).newStr = "Χ"
replacements(13).oldStr = "oo" : replacements(13).newStr = "w"
replacements(14).oldStr = "a"  : replacements(14).newStr = "α"
replacements(15).oldStr = "b"  : replacements(15).newStr = "β"
replacements(16).oldStr = "c"  : replacements(16).newStr = "κ"
replacements(17).oldStr = "d"  : replacements(17).newStr = "δ"
replacements(18).oldStr = "e"  : replacements(18).newStr = "ε"
replacements(19).oldStr = "f"  : replacements(19).newStr = "φ"
replacements(20).oldStr = "g"  : replacements(20).newStr = "γ"
replacements(21).oldStr = "h"  : replacements(21).newStr = "η"
replacements(22).oldStr = "i"  : replacements(22).newStr = "ι"
replacements(23).oldStr = "j"  : replacements(23).newStr = "ι"
replacements(24).oldStr = "k"  : replacements(24).newStr = "κ"
replacements(25).oldStr = "l"  : replacements(25).newStr = "λ"
replacements(26).oldStr = "m"  : replacements(26).newStr = "μ"
replacements(27).oldStr = "n"  : replacements(27).newStr = "ν"
replacements(28).oldStr = "o"  : replacements(28).newStr = "ο"
replacements(29).oldStr = "p"  : replacements(29).newStr = "π"
replacements(30).oldStr = "q"  : replacements(30).newStr = "κ"
replacements(31).oldStr = "r"  : replacements(31).newStr = "ρ"
replacements(32).oldStr = "s"  : replacements(32).newStr = "σ"
replacements(33).oldStr = "t"  : replacements(33).newStr = "τ"
replacements(34).oldStr = "u"  : replacements(34).newStr = "υ"
replacements(35).oldStr = "v"  : replacements(35).newStr = "β"
replacements(36).oldStr = "w"  : replacements(36).newStr = "ω"
replacements(37).oldStr = "x"  : replacements(37).newStr = "ξ"
replacements(38).oldStr = "y"  : replacements(38).newStr = "υ"
replacements(39).oldStr = "z"  : replacements(39).newStr = "ζ"
replacements(40).oldStr = "D"  : replacements(40).newStr = "Δ"
replacements(41).oldStr = "F"  : replacements(41).newStr = "Φ"
replacements(42).oldStr = "G"  : replacements(42).newStr = "Γ"
replacements(43).oldStr = "J"  : replacements(43).newStr = "I"
replacements(44).oldStr = "L"  : replacements(44).newStr = "Λ"
replacements(45).oldStr = "P"  : replacements(45).newStr = "Π"
replacements(46).oldStr = "Q"  : replacements(46).newStr = "Κ"
replacements(47).oldStr = "R"  : replacements(47).newStr = "Ρ"
replacements(48).oldStr = "S"  : replacements(48).newStr = "Σ"
replacements(49).oldStr = "Y"  : replacements(49).newStr = "U"
replacements(50).oldStr = "W"  : replacements(50).newStr = "Ω"
replacements(51).oldStr = "X"  : replacements(51).newStr = "Ξ"

' Special replacement for "s" at the end of a word or followed by a non-letter
Function replaceSigmaFinal(txt As String) As String
    Dim As String res = ""
    Dim As Integer i, l = Len(txt)
    For i = 1 To l
        If Mid(txt, i, 1) = "s" Then
            If i = l Or (Mid(txt, i+1, 1) < "A" Or (Mid(txt, i+1, 1) > "Z" And Mid(txt, i+1, 1) < "a") Or Mid(txt, i+1, 1) > "z") Then
                res &= "ς"
            Else
                res &= "s"
            End If
        Else
            res &= Mid(txt, i, 1)
        End If
    Next
    Return res
End Function

Function replaceString(ByVal txt As String, ByVal buscar As String, ByVal reemplazar As String) As String
    Dim As Integer posic = 1, lenBuscar = Len(buscar)
    Dim As String resultado = ""

    If lenBuscar = 0 Then Return txt ' Avoid infinite loop

    Do
        Dim As Integer idx = InStr(posic, txt, buscar)
        If idx = 0 Then
            resultado &= Mid(txt, posic)
            Exit Do
        End If
        resultado &= Mid(txt, posic, idx - posic) & reemplazar
        posic = idx + lenBuscar
    Loop

    Return resultado
End Function

Function replaceText(txt As String) As String
    txt = ReplaceSigmaFinal(txt)
    For i As Integer = 0 To UBound(replacements)
        txt = ReplaceString(txt, replacements(i).oldStr, replacements(i).newStr)
    Next
    Return txt
End Function

' Test program
For i As Integer = Lbound(texts) To Ubound(texts)
    Print texts(i)
    Print "=>"
    Print replaceText(texts(i))
    Print String(65, "=")
Next

Sleep
