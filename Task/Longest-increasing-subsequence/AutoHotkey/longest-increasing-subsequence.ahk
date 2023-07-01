Lists := [[3,2,6,4,5,1], [0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15]]

for k, v in Lists {
	D := LIS(v)
	MsgBox, % D[D.I].seq
}

LIS(L) {
	D := []
	for i, v in L {
		D[i, "Length"] := 1, D[i, "Seq"] := v, D[i, "Val"] := v
		Loop, % i - 1 {
			if(D[A_Index].Val < v && D[A_Index].Length + 1 > D[i].Length) {
				D[i].Length := D[A_Index].Length + 1
				D[i].Seq := D[A_Index].Seq ", " v
				if (D[i].Length > MaxLength)
					MaxLength := D[i].Length, D.I := i
			}
		}
	}
	return, D
}
