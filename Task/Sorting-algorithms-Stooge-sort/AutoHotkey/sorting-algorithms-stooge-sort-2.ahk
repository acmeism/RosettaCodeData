MsgBox % map(StoogeSort([123,51,6,73,3,-12,0]))
return

map(obj){
	for k, v in obj
		res .= v ","
	return trim(res, ",")
}
