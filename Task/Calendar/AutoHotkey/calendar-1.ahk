Calendar(Yr){
	LastDay := [], Day := []
	Titles =
	(ltrim
	______January_________________February_________________March_______
	_______April____________________May____________________June________
	________July___________________August_________________September_____
	______October_________________November________________December______
	)
	StringSplit, title, titles, `n
	Res := "________________________________" Yr "`r`n"

	loop 4 {										; 4 Vertical Sections
		Day[1]:=Yr SubStr("0" A_Index*3 -2, -1) 01
		Day[2]:=Yr SubStr("0" A_Index*3 -1, -1) 01
		Day[3]:=Yr SubStr("0" A_Index*3   , -1) 01
		Res .= "`r`n" title%A_Index% "`r`nSu Mo Tu We Th Fr Sa    Su Mo Tu We Th Fr Sa    Su Mo Tu We Th Fr Sa"
		loop , 6 {									; 6 Weeks max per month
			Week := A_Index, Res .= "`r`n"
			loop, 21 {								; 3 weeks times 7 days
				Mon := Ceil(A_Index/7), ThisWD := Mod(A_Index-1,7)+1
				FormatTime, WD, % Day[Mon], WDay
				FormatTime, dd, % Day[Mon], dd
				if (WD>ThisWD) {
					Res .= "__ "
					continue
				}
				dd := ((Week>3) && dd <10) ? "__" : dd, Res .= dd " ", LastDay[Mon] := Day[Mon], Day[Mon] +=1, Days
				Res .= ((wd=7) && A_Index < 21) ? "___" : ""	
				FormatTime, dd, % Day[Mon], dd
			}
		}
		Res .= "`r`n"
	}
	StringReplace, Res, Res,_,%A_Space%, all
	Res:=RegExReplace(Res,"`am)(^|\s)\K0", " ")
	return res
}
