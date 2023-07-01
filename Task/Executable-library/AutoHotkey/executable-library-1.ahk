#NoEnv
SetBatchLines, -1

; Check if we're executed directly:
If (A_LineFile = A_ScriptFullPath){
	h27 := hailstone(27)
	MsgBox % "Length of hailstone 27: " (m := h27.MaxIndex()) "`nStarts with "
		. h27[1] ", " h27[2] ", " h27[3] ", " h27[4]
		. "`nEnds with "
		. h27[m-3] ", " h27[m-2] ", " h27[m-1] ", " h27[m]
	
	Loop 100000
	{
		h := hailstone(A_Index)
		If (h.MaxIndex() > m)
			m := h.MaxIndex(), longest := A_Index
	}
	MsgBox % "Longest hailstone is that of " longest " with a length of " m "!"
}


hailstone(n){
	out := [n]
	Loop
		n := n & 1 ? n*3+1 : n//2, out.insert(n)
	until n=1
	return out
}
