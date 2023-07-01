factors(num)	New fctr,list,sep,sqrt
	If num<1 Quit "Too small a number"
	If num["." Quit "Not an integer"
	Set sqrt=num**0.5\1
	For fctr=1:1:sqrt Set:num/fctr'["." list(fctr)=1,list(num/fctr)=1
	Set (list,fctr)="",sep="[" For  Set fctr=$Order(list(fctr)) Quit:fctr=""  Set list=list_sep_fctr,sep=","
	Quit list_"]"

w $$factors(45) ; [1,3,5,9,15,45]
w $$factors(53) ; [1,53]
w $$factors(64) ; [1,2,4,8,16,32,64]
