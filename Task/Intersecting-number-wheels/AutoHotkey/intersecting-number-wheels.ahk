obj1 := {"A":[1, 2, 3]}
obj2 := {"A":[1, "B", 2]	, "B":[3, 4]}
obj3 := {"A":[1, "D", "D"]	, "D":[6, 7, 8]}
obj4 := {"A":[1, "B", "C"]	, "B":[3, 4]	, "C":[5, "B"]}

loop 4
{
	str := ""
	for k, v in obj%A_Index% {
		str .= "{" k " : "
		for i, t in v
			str .= t ","
		str := Trim(str, ",") "}, "
	}
	str := Trim(str, ", ")
	x := INW(obj%A_Index%)
	result .= str "`n" x.1 "`n" x.2 "`n------`n"
}
MsgBox % result
return

INW(obj, num:=20){
	sets := [], ptr := []
	for k, v in obj {
		if A_Index=1
			s := k, s1 := k
		%k% := v, sets.Push(k), ptr[k] := 0
	}
	loop % num {
		ptr[s]++				
		while !((v := %s%[ptr[s]]) ~= "\d") {
			s := %s%[ptr[s]]
			ptr[s]++
		}
		key .= s "." ptr[s] ", "
		result .= %s%[ptr[s]] "    "
		s := s1
		for i, set in sets
			ptr[set] := ptr[set] = %set%.count() ? 0 : ptr[set]
	}
	return [key, result]
}
