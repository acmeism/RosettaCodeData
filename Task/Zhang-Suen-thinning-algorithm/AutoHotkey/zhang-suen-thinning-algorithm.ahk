FileIn  := A_ScriptDir "\Zhang-Suen.txt"
FileOut := A_ScriptDir "\NewFile.txt"

if (!FileExist(FileIn)) {
	MsgBox, 48, File Not Found, % "File """ FileIn """ not found."
	ExitApp
}
S := {}
N := [2,3,4,5,6,7,8,9,2]

Loop, Read, % FileIn
{
	LineNum := A_Index
	Loop, Parse, A_LoopReadLine
		S[LineNum, A_Index] := A_LoopField
}

Loop {
	FlipCount := 0
	Loop, 2 {
		Noted := [], i := A_Index
		for LineNum, Line in S {
			for PixNum, Pix in Line {
			; (0)
				if (Pix = 0 || (P := GetNeighbors(LineNum, PixNum, S)) = 1)
					continue
			; (1)	
				BP := 0
				for j, Val in P
					BP += Val
				if (BP < 2 || BP > 6)
					continue
			; (2)
				AP := 0
				Loop, 8
					if (P[N[A_Index]] = "0" && P[N[A_Index + 1]] = "1")
						AP++
				if (AP != 1)
					continue
			; (3 and 4)
				if (i = 1) {
					if (P[2] + P[4] + P[6] = 3 || P[4] + P[6] + P[8] = 3)
						continue
				}
				else if (P[2] + P[4] + P[8] = 3 || P[2] + P[6] + P[8] = 3)
					continue
				
				Noted.Insert([LineNum, PixNum])
				FlipCount++
			}
		}
		for j, Coords in Noted
			S[Coords[1], Coords[2]] := 0
	}
	if (!FlipCount)
		break
}

for LineNum, Line in S {
	for PixNum, Pix in Line
		Out .= Pix ? "#" : " "
	Out .= "`n"
}
FileAppend, % Out, % FileOut

GetNeighbors(Y, X, S) {
	Neighbors := []
	if ((Neighbors[8] := S[Y, X - 1]) = "")
		return 1
	if ((Neighbors[4] := S[Y, X + 1]) = "")
		return 1
	Loop, 3
		if ((Neighbors[A_Index = 1 ? 9 : A_Index] := S[Y - 1, X - 2 + A_Index]) = "")
			return 1
	Loop, 3
		if ((Neighbors[8 - A_Index] := S[Y + 1, X - 2 + A_Index]) = "")
			return 1
	return Neighbors
}
