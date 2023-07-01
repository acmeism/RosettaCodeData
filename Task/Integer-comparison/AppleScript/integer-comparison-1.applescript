set n1 to text returned of (display dialog "Enter the first number:" default answer "") as integer
set n2 to text returned of (display dialog "Enter the second number:" default answer "") as integer
set msg to {n1}
if n1 < n2 then
	set end of msg to " is less than "
else if n1 = n2 then
	set end of msg to " is equal to "
else if n1 > n2 then
	set end of msg to " is greater than "
end if
set end of msg to n2
return msg as string
