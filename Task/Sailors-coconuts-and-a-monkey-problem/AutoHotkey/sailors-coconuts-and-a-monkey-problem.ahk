loop, 2
{
	sailor := A_Index+4
	while !result := Coco(sailor, A_Index)
		continue
	; format output
	remain := result["Coconuts"]
	output := sailor  " Sailors, Number of coconuts = " result["Coconuts"] "`n"
	loop % sailor {
		x := result["Sailor_" A_Index]
		output .= "Monkey gets 1, Sailor# " A_Index " hides (" remain "-1)/" sailor " = " x ", remainder = " (remain -= x+1) "`n"
	}
	output .= "Remainder = " result["Remaining"] "/" sailor " = " floor(result["Remaining"] / sailor)
	MsgBox % output
}
return

Coco(sailor, coconut){
	result := [], result["Coconuts"] := coconut
	loop % sailor {
		if (Mod(coconut, sailor) <> 1)
			return
		result["Sailor_" A_Index] := Floor(coconut/sailor)
		coconut -= Floor(coconut/sailor) + 1
	}
	if Mod(coconut, sailor) || !coconut
		return
	result["Remaining"] := coconut
	return result
}
