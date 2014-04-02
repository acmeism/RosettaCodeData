aa:=[1,0.5,0]
bb:=[1,0.5,0]

for index, a in aa
	Res .= "`tTernary_Not`t" a "`t=`t" Ternary_Not(a) "`n"
Res .= "-------------`n"

for index, a in aa
	for index, b in bb
		Res .= a "`tTernary_And`t" b "`t=`t" Ternary_And(a,b) "`n"
Res .= "-------------`n"

for index, a in aa
	for index, b in bb
		Res .= a "`tTernary_or`t" b "`t=`t" Ternary_Or(a,b) "`n"
Res .= "-------------`n"

for index, a in aa
	for index, b in bb
		Res .= a "`tTernary_then`t" b "`t=`t" Ternary_IfThen(a,b) "`n"
Res .= "-------------`n"

for index, a in aa
	for index, b in bb
		Res .= a "`tTernary_equiv`t" b "`t=`t" Ternary_Equiv(a,b) "`n"

StringReplace, Res, Res, 1, true, all
StringReplace, Res, Res, 0.5, maybe, all
StringReplace, Res, Res, 0, false, all
MsgBox % Res
return
