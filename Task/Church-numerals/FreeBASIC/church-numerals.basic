Type church
    ' eg {r_add,1,{a,b}}
    op As Integer
    n As Integer
    x(1 To 2) As Integer
End Type

Dim Shared As church zero = Type<church>(1, 0, {0, 1})

Function succ(c As church) As church
    ' eg {r_add,1,{a,b}} => {r_add,2,{a,b}}  aka  a+b -> a+b+b
    c.n += 1
    Return c
End Function

' three normal integer-handling routines...
Function sum(n As Integer, a As Integer, b As Integer) As Integer
    For i As Integer = 1 To n
        a += b
    Next i
    Return a
End Function

Function mul(n As Integer, a As Integer, b As Integer) As Integer
    For i As Integer = 1 To n
        a *= b
    Next i
    Return a
End Function

Function pow(n As Integer, a As Integer, b As Integer) As Integer
    For i As Integer = 1 To n
        a = a ^ b
    Next i
    Return a
End Function

' ...and three church constructors to match
'    (no maths here, just pure static data)
Function churchSum(c As church, d As church) As church
    Dim res As church
    res.op = 1 ' 1 for add
    res.n = 1
    res.x(1) = c.n
    res.x(2) = d.n
    Return res
End Function

Function churchMul(c As church, d As church) As church
    Dim res As church
    res.op = 2 ' 2 for mul
    res.n = 1
    res.x(1) = c.n
    res.x(2) = d.n
    Return res
End Function

Function churchPow(c As church, d As church) As church
    Dim res As church
    res.op = 3 ' 3 for pow
    res.n = 1
    res.x(1) = c.n
    res.x(2) = d.n
    Return res
End Function

Function churchToNum(c As church) As Integer
    ' note this is where the bulk of any processing happens
    Select Case c.op
    Case 1
        Return sum(c.n, c.x(1), c.x(2))
    Case 2
        Return mul(c.n, c.x(1), c.x(2))
    Case 3
        Return pow(c.n, c.x(1), c.x(2))
    End Select
End Function

Function numToChurch(i As Integer) As church
    Return Iif(i = 0, zero, succ(numToChurch(i - 1)))
End Function

Dim As church three = succ(succ(succ(zero)))
Dim As church four  = succ(three)
Print "three        -> "; churchToNum(three)
Print "four         -> "; churchToNum(four)
Print "three + four -> "; churchToNum(churchSum(three, four))
Print "three * four -> "; churchToNum(churchMul(three, four))
Print "three ^ four -> "; churchToNum(churchPow(three, four))
Print "four ^ three -> "; churchToNum(churchPow(four, three))
Print "5 -> five    -> "; churchToNum(numToChurch(5))

Sleep
