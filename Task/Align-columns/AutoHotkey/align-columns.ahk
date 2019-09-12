Alignment := "L"																				; Options: L, R, C
Text =
( LTrim
	Given$a$text$file$of$many$lines,$where$fields$within$a$line$
	are$delineated$by$a$single$'dollar'$character,$write$a$program
	that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
	column$are$separated$by$at$least$one$space.
	Further,$allow$for$each$word$in$a$column$to$be$either$left$
	justified,$right$justified,$or$center$justified$within$its$column.
)

Loop, Parse, Text																				; calculate column's width
	If A_LoopField in $,`n
		If (N > W)
			W := N, N := 0
		Else
			N := 0
	Else
		++N
Width := ++W

Loop, Parse, Text, `n																			; process each line
{
	Words := StrSplit(A_LoopField, "$")
	For i, Word in Words																		; process each word
		Line .= Align(Word, Alignment, Width)
	Result .= RTrim(Line) . "`n"
	Line := ""
}

Clipboard := Result																				; present results
MsgBox, The results are in the Clipboard

Align(Pal, How, Width) {																		; function for alignment
	Length := StrLen(Pal)
	If (How = "L")
		Return Pal . Spc(Width - Length)
	Else If (How = "R")
		Return Spc(Width - Length) . Pal
	Else If (How = "C")
		Return Spc((Width - Length)//2) . Pal . Spc(Width - Length - (Width - Length)//2)
}

Spc(Number) {																					; function to concatenate space characters
	Loop, %Number%
		Ret .= A_Space
	Return Ret
}
