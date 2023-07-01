CALENDAR(YR){
	LASTDAY := [], DAY := []
	TITLES =
	(LTRIM
	______JANUARY_________________FEBRUARY_________________MARCH_______
	_______APRIL____________________MAY____________________JUNE________
	________JULY___________________AUGUST_________________SEPTEMBER_____
	______OCTOBER_________________NOVEMBER________________DECEMBER______
	)
	STRINGSPLIT, TITLE, TITLES, % CHR(10)
	RES := "________________________________" YR CHR(13) CHR(10)

	LOOP 4 {												; 4 VERTICAL SECTIONS
		DAY[1]:=YR SUBSTR("0" A_INDEX*3 -2, -1) 01
		DAY[2]:=YR SUBSTR("0" A_INDEX*3 -1, -1) 01
		DAY[3]:=YR SUBSTR("0" A_INDEX*3   , -1) 01
		RES .= CHR(13) CHR(10) TITLE%A_INDEX% CHR(13) CHR(10) "SU MO TU WE TH FR SA    SU MO TU WE TH FR SA    SU MO TU WE TH FR SA"
		LOOP , 6 {											; 6 WEEKS MAX PER MONTH
			WEEK := A_INDEX, RES .= CHR(13) CHR(10)
			LOOP, 21 {										; 3 WEEKS TIMES 7 DAYS
				MON := CEIL(A_INDEX/7), THISWD := MOD(A_INDEX-1,7)+1
				FORMATTIME, WD, % DAY[MON], WDAY
				;~ MSGBOX % WD
				FORMATTIME, DD, % DAY[MON], % CHR(100) CHR(100)
				IF (WD>THISWD) {
					RES .= "__ "
					CONTINUE
				}
				DD := ((WEEK>3) && DD <10) ? "__" : DD, RES .= DD " ", LASTDAY[MON] := DAY[MON], DAY[MON] +=1, D
				RES .= ((WD=7) && A_INDEX < 21) ? "___" : ""
				FORMATTIME, DD, % DAY[MON], % CHR(100) CHR(100)
			}
		}
		RES .= CHR(13) CHR(10)
	}
	STRINGREPLACE, RES, RES,_,%A_SPACE%, ALL
	STRINGREPLACE, RES, RES,%A_SPACE%0,%A_SPACE%%A_SPACE%, ALL
	RETURN RES
}
