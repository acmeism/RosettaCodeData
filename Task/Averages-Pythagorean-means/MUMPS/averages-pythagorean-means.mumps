Pyth(n)	New a,ii,g,h,x
	For ii=1:1:n set x(ii)=ii
	;
	; Average
	Set a=0 For ii=1:1:n Set a=a+x(ii)
	Set a=a/n
	;
	; Geometric
	Set g=1 For ii=1:1:n Set g=g*x(ii)
	Set g=g**(1/n)
	;
	; Harmonic
	Set h=0 For ii=1:1:n Set h=1/x(ii)+h
	Set h=n/h
	;
	Write !,"Pythagorean means for 1..",n,":",!
	Write "Average = ",a," >= Geometric ",g," >= harmonic ",h,!
	Quit
Do Pyth(10)

Pythagorean means for 1..10:
Average = 5.5 >= Geometric 4.528728688116178495 >= harmonic 3.414171521474055006
