##
function IsLeapYear(year: word): boolean :=
   if year mod 100 = 0 then year mod 400 = 0
   else year mod 4 = 0;

IsLeapYear(2000).println;
