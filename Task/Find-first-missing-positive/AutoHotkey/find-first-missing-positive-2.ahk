nums := [[1,2,0], [3,4,-1,1], [7,8,9,11,12], [-4,-2,-3], []]
for i, obj in nums{
    m := First_Missing_Positive(obj)
    output .= m ", "
}
MsgBox % Trim(output, ", ")
return
