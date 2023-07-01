; task
l1	:= [0, -1, -1]
lo1	:= [0, 0, 10]
n1	:= [0, 0, 1]
Po1	:= [0, 0, 5]

; line on plane
l2	:= [1, 1, 0]
lo2	:= [1, 1, 0]
n2	:= [0, 0, 1]
Po2	:= [5, 1, 0]

; line parallel to plane
l3	:= [1, 1, 0]
lo3	:= [1, 1, 1]
n3	:= [0, 0, 1]
Po3	:= [5, 1, 0]

output := ""
loop 3
{
	result := ""
	ip := intersectPoint(l%A_Index%, lo%A_Index%, n%A_Index%, Po%A_Index%)
	for i, v in ip
		result .= v ", "
	output .= Trim(result, ", ") "`n"
}
MsgBox % output
return
