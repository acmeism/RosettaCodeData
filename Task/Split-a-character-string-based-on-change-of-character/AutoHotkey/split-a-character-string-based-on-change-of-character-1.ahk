Split_Change(str){
	for i, v in StrSplit(str)
		res .= (v=prev) ? v : (res?", " :"") v	, prev := v
	return res
}
