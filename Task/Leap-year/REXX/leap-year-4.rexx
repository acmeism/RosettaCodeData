leapyear:  procedure;  parse arg y          /*year could be: Y, YY, YYY, YYYY*/
if y//4\==0      then return 0              /*Not ÷ by 4?    Not a leap year.*/
if length(y)==2  then y=left(date('S'),2)y  /*adjust for a 2─digit  YY  year.*/
return y//100\==0 | y//400==0               /*apply  100 and 400  year rule. */
* * * End of File * * *
