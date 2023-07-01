#NoEnv
#Include %A_ScriptDir%\hailstone.ahk
SetBatchLines -1

col := Object(), highestCount := 0

Loop 100000
{
	length := hailstone(A_Index).MaxIndex()
	if not col[length]
		col[length] := 0
	col[length]++
}
for length, count in col
	if (count > highestCount)
		highestCount := count, highestN := length
MsgBox % "the most common length was " highestN "; it occurred " highestCount " times."
