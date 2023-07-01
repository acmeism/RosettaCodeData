#NoEnv
SetBatchLines, -1
Ludic := LudicSieve(22000)

Loop, 25    ; the first 25 ludic numbers
	Task1 .= Ludic[A_Index] " "

for i, Val in Ludic    ; the number of ludic numbers less than or equal to 1000
	if (Val <= 1000)
		Task2++
	else
		break

Loop, 6    ; the 2000..2005'th ludic numbers
	Task3 .= Ludic[1999 + A_Index] " "

for i, Val in Ludic {    ; all triplets of ludic numbers < 250
	if (Val + 6 > 249)
		break
	if (Ludic[i + 1] = Val + 2 && Ludic[i + 2] = Val + 6 || i = 1)
		Task4 .= "(" Val " " Val + 2 " " Val + 6 ") "
}

MsgBox, % "First 25:`t`t" Task1
	. "`nLudics below 1000:`t" Task2
	. "`nLudic 2000 to 2005:`t" Task3
	. "`nTriples below 250:`t" Task4
return

LudicSieve(Limit) {
	Arr := [], Ludic := []
	Loop, % Limit
		Arr.Insert(A_Index)
	Ludic.Insert(Arr.Remove(1))
	while Arr.MaxIndex() != 1 {
		Ludic.Insert(n := Arr.Remove(1))
		, Removed := 0
		Loop, % Arr.MaxIndex() // n {
			Arr.Remove(A_Index * n - Removed)
			, Removed++
		}
	}
	Ludic.Insert(Arr[1])
	return Ludic
}
