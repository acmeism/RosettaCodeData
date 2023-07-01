factorial(num)	New ii,result
	If num<0 Quit "Negative number"
	If num["." Quit "Not an integer"
	Set result=1 For ii=1:1:num Set result=result*ii
	Quit result

Write $$factorial(0) ; 1
Write $$factorial(1) ; 1
Write $$factorial(2) ; 2
Write $$factorial(3) ; 6
Write $$factorial(10) ; 3628800
Write $$factorial(-6) ; Negative number
Write $$factorial(3.7) ; Not an integer
