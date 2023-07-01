define isLeapYear(y::integer) => {
	#y % 400 == 0 ? return true
	#y % 100 == 0 ? return false
	#y % 4 == 0 ? return true
	return false
}

with test in array(2012,2016,1933,1900,1999,2000) do => {^
	isLeapYear(#test)
	'\r'
^}
