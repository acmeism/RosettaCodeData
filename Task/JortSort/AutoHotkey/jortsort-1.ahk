JortSort(Array){
	sorted:=[]
	for index, val in Array
		sorted[val]:=1
	for key, val in sorted
		if (key<>Array[A_Index])
			return 0
	return 1
}
