give year
leap = isLeapYear(year)
if leap true see year + " is leap year."
else see year + " is not leap year." ok

Func isLeapYear year
     if (year % 400) = 0 return true
        but (year % 100) = 0 return false
        but (year % 4) = 0 return true
        else return false ok
