Function gcd(u As Long, v As Long) As Long
    Dim t As Long
    Do While v
        t = u
        u = v
        v = t Mod v
    Loop
    gcd = u
End Function
