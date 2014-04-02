data =
(
3	Clear drains
1	test
4	Feed cat
5	Make tea
1	Solve RC tasks
2	Tax return
)
PQ:=[] 								; Create Priority Queue PQ[Task, Priority]
loop, parse, data, `n, `r
	F:= StrSplit(A_LoopField, "`t")	, PQ[F[2]] := F[1]
PQ_View(PQ)
MsgBox, 262208,, % "Top Priority item(s)=`n" 			PQ_Peek(PQ)	"`n`n" PQ_View(PQ)
MsgBox, 262208,, % "Add : " 					PQ_AddTask(PQ, "AutoHotkey", 2)	"`n`n" PQ_View(PQ)
MsgBox, 262208,, % "Remove Top Item : " 			PQ_TopItem(PQ) "`n`n" PQ_View(PQ)
MsgBox, 262208,, % "Remove specific top item : " 		PQ_TopItem(PQ,"test") "`n`n" PQ_View(PQ)
MsgBox, 262208,, % "Delete Item : " 				PQ_DelTask(PQ, "Clear drains")	"`n`n" PQ_View(PQ)
MsgBox, 262208,, % (Task:="Tax return") " new priority = "	PQ_Edit(PQ,task, 7)	"`n`n" PQ_View(PQ)
MsgBox, 262208,, % (Task:="Feed cat")  " priority = " 		PQ_Check(PQ,task)"`n`n" PQ_View(PQ)
^Esc::
ExitApp
