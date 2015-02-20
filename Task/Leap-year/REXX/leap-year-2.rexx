leapyear:  procedure;   parse arg yr
if y//4\==0  then return 0                  /*Not ÷ by 4?    Not a leap year.*/
return  yr//400==0  |  yr//100\==0
