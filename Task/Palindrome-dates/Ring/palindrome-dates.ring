load "stdlib.ring"

dt		= 0
num		= 0
limit	        = 15

? "First 15 palindromic dates:" + nl

while num < limit

	dt++
	dateStr  = adddays(date(),dt)
	newDate  = substr(dateStr,7,4) + substr(dateStr,4,2) + substr(dateStr,1,2)
	newDate2 = substr(dateStr,7,4) + "-" + substr(dateStr,4,2) + "-" + substr(dateStr,1,2)
	if ispalindrome(newDate)
                num++
		? newDate2 	
	ok
	if num > limit
		exit
	ok

end
