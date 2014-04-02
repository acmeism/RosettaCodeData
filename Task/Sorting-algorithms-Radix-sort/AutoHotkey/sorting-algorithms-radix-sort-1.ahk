Radix_Sort(data){
	loop, parse, data, `,
		n := StrLen(A_LoopField)>n?StrLen(A_LoopField):n
	loop % n {
		bucket := []	,	i := A_Index
		loop, parse, data, `,
			bucket[SubStr(A_LoopField,1-i)] .= (bucket[SubStr(A_LoopField,1-i)]?",":"") A_LoopField
		data := ""
		for i, v in bucket
			data .= (data?",":"") v
	}
	return data
}
