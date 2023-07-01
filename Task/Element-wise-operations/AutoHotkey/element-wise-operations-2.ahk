M := [[1, 2, 3]
,     [4, 5, 6]
,     [7, 8, 9]]
output :=  "M`t=`t" obj2str(M) "`n"
output .=  "M + 2`t=`t" obj2str(ElementWise(M, "+", 2)) "`n"
output .=  "M - 2`t=`t" obj2str(ElementWise(M, "-", 2)) "`n"
output .=  "M * 2`t=`t" obj2str(ElementWise(M, "*", 2)) "`n"
output .=  "M / 2`t=`t" obj2str(ElementWise(M, "/", 2)) "`n"
output .=  "M Mod 2`t=`t" obj2str(ElementWise(M, "Mod", 2)) "`n"
output .=  "M ^ 2`t=`t" obj2str(ElementWise(M, "^", 2)) "`n"
output .=   "`n"
output .=  "M + M`t=`t" obj2str(ElementWise(M, "+", M)) "`n"
output .=  "M - M`t=`t" obj2str(ElementWise(M, "-", M)) "`n"
output .=  "M * M`t=`t" obj2str(ElementWise(M, "*", M)) "`n"
output .=  "M / M`t=`t" obj2str(ElementWise(M, "/", M)) "`n"
output .=  "M Mod M`t=`t" obj2str(ElementWise(M, "Mod", M)) "`n"
output .=  "M ^ M`t=`t" obj2str(ElementWise(M, "^", M)) "`n"
MsgBox % output
return

obj2str(A){
    output := "["
    for r, obj in A{
        output .= "["
        for c, v in obj
            output .= v ", "
        output := Trim(output, ", ") "], "
    }
    return output := Trim(output, ", ") "]"
}
