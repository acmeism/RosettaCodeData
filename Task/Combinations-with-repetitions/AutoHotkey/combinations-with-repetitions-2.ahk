result := CombinationRepetition(["iced","jam","plain"], 2, " + ")
for k, v in result
	res .=  v "`n"
res := trim(res, ",") "`n"
MsgBox % result.count() " Combinations with Repetition found:`n" res
MsgBox % CombinationRepetition([0,1,2,3,4,5,6,7,8,9], 3).Count()
