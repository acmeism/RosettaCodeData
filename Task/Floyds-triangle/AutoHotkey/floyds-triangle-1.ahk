Floyds_triangle(row){
	i = 0
	loop %row%
	{
		n := A_Index
		loop, %n%
		{
			m := n, j := i, i++
			while (m<row)
				j += m , m++
			res .= spaces(StrLen(j+1)-StrLen(i) +(A_Index=1?0:1)) i
		}
		if (A_Index < row)
			res .= "`r`n"
	}	
	return res
}
Spaces(no){
	loop, % no
		res.=" "
	return % res
}
