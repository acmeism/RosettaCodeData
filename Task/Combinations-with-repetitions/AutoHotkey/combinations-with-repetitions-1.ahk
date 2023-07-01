;===========================================================
; based on "https://www.geeksforgeeks.org/combinations-with-repetitions/"
;===========================================================
CombinationRepetition(arr, k:=0, Delim:="") {
	CombinationRepetitionUtil(arr, k?k:str.count(), Delim, [k+1], result:=[])
	return result
} ;===========================================================
CombinationRepetitionUtil(arr, k, Delim, chosen, result , index:=1, start:=1){
	line := [], i:=0, 	res := ""
	if (index = k+1){
		while (++i <= k)
			res .= arr[chosen[i]] Delim,	line.push(arr[chosen[i]])
		return result.Push(Trim(res, Delim))
	}
	i:=start
	while (i <= arr.count())
		chosen[Index]:=i, 	CombinationRepetitionUtil(arr, k, Delim, chosen, result, index+1, i++)
} ;===========================================================
