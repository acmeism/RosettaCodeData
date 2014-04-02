test(Set,element){
	for i, val in Set
		if (val=element)
			return true
	return false
}

Union(SetA,SetB){
	SetC:=[], Temp:=[]
	for i, val in SetA
		SetC.Insert(val), Temp[val] := true
	for i, val in SetB
		if !Temp[val]
			SetC.Insert(val)
	return SetC
}

intersection(SetA,SetB){
	SetC:=[], Temp:=[]
	for i, val in SetA
		Temp[val] := true
	for i, val in SetB
		if Temp[val]
			SetC.Insert(val)
	return SetC
}

difference(SetA,SetB){
	SetC:=[], Temp:=[]
	for i, val in SetB
		Temp[val] := true
	for i, val in SetA
		if !Temp[val]
			SetC.Insert(val)
	return SetC
}

subset(SetA,SetB){
	Temp:=[], A:=B:=0
	for i, val in SetA
		Temp[val] := true , A++
	for i, val in SetB
		if Temp[val]{
			B++
			IfEqual, A, %B%, return 1
		} return 0
}

equal(SetA,SetB){
	return (SetA.MaxIndex() = SetB.MaxIndex() && subset(SetA,SetB)) ? 1: 0
}
