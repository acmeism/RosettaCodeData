ConsoleWrite(Fibonacci(10) & @CRLF)						; ## USAGE EXAMPLE
ConsoleWrite(Fibonacci(20) & @CRLF)						; ## USAGE EXAMPLE
ConsoleWrite(Fibonacci(30))						        ; ## USAGE EXAMPLE

Func Fibonacci($number)

	If $number < 0 Then Return "Invalid argument" 				; No negative numbers

	If $number < 2 Then 							; If $number equals 0 or 1
		Return $number  						; then return that $number
	Else									; Else $number equals 2 or more
		Return Fibonacci($number - 1) + Fibonacci($number - 2) 		; FIBONACCI!
	EndIf

EndFunc
