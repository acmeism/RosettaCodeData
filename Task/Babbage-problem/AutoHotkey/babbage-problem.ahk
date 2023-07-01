; Give n an initial value
n = 519

; Loop this action while condition is not satisfied
while (Mod(n*n, 1000000) != 269696) {
	; Increment n
	n++
}

; Display n as value
msgbox, %n%
