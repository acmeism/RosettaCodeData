leapyear:  procedure;    parse arg yr
return  yr//400==0  |  (yr//100\==0  &  yr//4==0)
