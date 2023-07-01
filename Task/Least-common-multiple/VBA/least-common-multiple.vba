Function gcd(u As Long, v As Long) As Long
    Dim t As Long
    Do While v
        t = u
        u = v
        v = t Mod v
    Loop
    gcd = u
End Function
Function lcm(m As Long, n As Long) As Long
    lcm = Abs(m * n) / gcd(m, n)
End Function
