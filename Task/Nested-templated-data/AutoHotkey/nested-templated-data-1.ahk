;-----------------------------------------------------------
Nested_templated_data(template, Payload){
	UsedP := [], UnusedP := [], UnusedI := []
	result := template.Clone()
	x := ArrMap(template, Payload, result, UsedP, UnusedI, [])
	for i, v in Payload
		if !UsedP[v]
			UnusedP.Push(v)
	return [x.1, x.2, UnusedP]
}
;-----------------------------------------------------------
ArrMap(Template, Payload, result, UsedP, UnusedI, pth){
	for i, index in Template	{
		if IsObject(index)
			pth.Push(i),	Arrmap(index, Payload, result, UsedP, UnusedI, pth)
		else{
			pth.Push(i),	ArrSetPath(result, pth, Payload[index])
			if Payload[index]
				UsedP[Payload[index]] := 1
			else
				UnusedI.Push(index)
		}
		pth.Pop()
	}
	return [result, UnusedI, UsedP]
}
;-----------------------------------------------------------
ArrSetPath(Arr, pth, newVal){
	temp := []
	for k, v in pth{
		temp.push(v)
		if !IsObject(Arr[temp*])
			Arr[temp*] := []
	}
	return Arr[temp*] := newVal
}
;-----------------------------------------------------------
objcopy(obj){
	nobj := obj.Clone()
	for k, v in nobj
		if IsObject(v)
			nobj[k] := objcopy(v)
	return nobj
}
;-----------------------------------------------------------
