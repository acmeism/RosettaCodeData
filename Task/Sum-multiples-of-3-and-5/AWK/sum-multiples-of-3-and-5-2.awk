Declare function mulsum35(n as integer) as integer
Function mulsum35(n as integer) as integer
    Dim s as integer
    For i as integer = 1 to n - 1
        If (i mod 3 = 0) or (i mod 5 = 0) then
            s += i
        End if
    Next i
    Return s
End Function
Print mulsum35(1000)
Sleep
End
