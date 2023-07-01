begin
	integer year;

	integer procedure mod(i,j); value i,j; integer i,j;
	mod:=i-(i div j)*j;

	boolean procedure isLeapYear(year); value year; integer year;
	isLeapYear:=mod(year,400)=0 or (mod(year,4)=0 and mod(year,100) notequal 0);

	for year := 1899, 1900, 1901, 1902, 1903, 1904, 1905, 1999, 2000, 2001, 2002, 2003, 2004 do begin
		outinteger(1,year);
		if isLeapYear(year) then outstring(1,"True\n") else outstring(1, "False\n")
	end for year
end
