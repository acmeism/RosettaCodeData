MsgBox, % TimeFunction("fx")

TimeFunction(Function, Parameters*) {
	SetBatchLines, -1						; SetBatchLines sets the speed of which every new line of coe is run.
	DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)	; Start the counter.
	DllCall("QueryPerformanceFrequency", "Int64*", Freq)		; Get the frequency of the counter.
	%Function%(Parameters*)						; Call the function with it's parameters.
	DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)	; End the counter.

	; Calculate the speed of which it counted.
	Return, (((CounterAfter - CounterBefore) / Freq) * 1000) . " milliseconds."
}

fx() {
	Sleep, 1000
}
