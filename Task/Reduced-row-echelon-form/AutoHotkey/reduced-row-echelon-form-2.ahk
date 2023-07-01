M :=  [[1 , 2, -1, -4 ]
    , [2 , 3, -1, -11]
    , [-2, 0, -3,  22]]

M := ToReducedRowEchelonForm(M)
for row, obj in M
{
    for col, v in obj
        output .= RegExReplace(v, "\.0+$|0+$") "`t"
    output .= "`n"
}
MsgBox % output
return
