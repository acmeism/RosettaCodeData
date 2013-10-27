leapyear:  procedure;  parse arg y     /*year could be: Y, YY, YYY, YYYY*/
if length(y)==2 then y=left(right(date(),4),2)y    /*adjust for YY year.*/
if y//4\==0 then return 0              /* not ÷ by 4?   Not a leap year.*/
return y//100\==0 | y//400==0          /*apply 100 and 400 year rule.   */
