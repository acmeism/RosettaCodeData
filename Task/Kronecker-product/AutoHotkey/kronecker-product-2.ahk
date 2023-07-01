a := [[1, 2], [3, 4]]
b := [[0, 5], [6, 7]]
P := KroneckerProduct(a, b)

a :=[[0,1,0], [1,1,1], [0,1,0]]
b := [[1,1,1,1], [1,0,0,1], [1,1,1,1]]
Q := KroneckerProduct(a, b)

; show results
for row, obj in P
{
    for col, v in obj
        result .= v "`t"
    result .= "`n"
}
result .= "`n"
for row, obj in Q
{
    for col, v in obj
        result .= v "`t"
    result .= "`n"
}
MsgBox % result
return
