MsgBox % time("fx")

time(function, parameter=0){
	SetBatchLines -1
	DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
	DllCall("QueryPerformanceFrequency", "Int64*", Freq)
	%function%(parameter)
	DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
	return (CounterAfter-CounterBefore)/Freq * 1000 " milliseconds"
}

fx(){
	Sleep 1000
}
