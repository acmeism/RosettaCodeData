set n1 to text returned of (display dialog "Enter the first number:" default answer "") as integer
set n2 to text returned of (display dialog "Enter the second number:" default answer "") as integer
if n1 < n2 then return "" & n1 & " is less than " & n2
if n1 = n2 then return "" & n1 & " is equal to " & n2
if n1 > n2 then return "" & n1 & " is greater than " & n2
