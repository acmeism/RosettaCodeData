factorial(num)	;
	If num<0 Quit "Negative number"
	If num["." Quit "Not an integer"
	If num<2 Quit 1
	Quit num*$$factorial(num-1)

Write $$factorial(0) ; 1
Write $$factorial(1) ; 1
Write $$factorial(2) ; 2
Write $$factorial(3) ; 6
Write $$factorial(10) ; 3628800
Write $$factorial(-6) ; Negative numberr
Write $$factorial(3.7) ; Not an integer
