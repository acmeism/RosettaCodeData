/*REXX pgm  finds and displays  N  numbers that have an equal number of rises and falls,*/
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 200                   /*Not specified?  Then use the default.*/
append= n>0                                      /*a flag that is used to append numbers*/
n= abs(n)                                        /*use the absolute value of  N.        */
call init                                        /*initialize the  rise/fall  database. */
          do j=1  until #==n                     /*test integers until we have N of them*/
          s= 0                                   /*initialize the sum of  rises/falls.  */
                        do k=1  for length(j)-1  /*obtain a set of two digs from number.*/
                        t= substr(j, k, 2)       /*obtain a set of two digs from number.*/
                        s= s + @.t               /*sum the rises and falls in the number*/
                        end   /*k*/
          if s\==0  then iterate                 /*Equal # of rises & falls? Then add it*/
          #= # + 1                               /*bump the count of numbers found.     */
          if append  then $= $ j                 /*append to the list of numbers found. */
          end   /*j*/

if append  then call show                        /*display a list of  N  numbers──►term.*/
           else say  'the '  commas(n)th(n)  " number is: "   commas(j)    /*show Nth #.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _;  do c=length(_)-3  to 1  by -3; _=insert(',', _, c); end;   return _
th:      parse arg th;  return word('th st nd rd',1+(th//10)*(th//100%10\==1)*(th//10<4))
/*──────────────────────────────────────────────────────────────────────────────────────*/
init: @.= 0;   do i=1  for 9;    _= i' ';     @._= 1;    _= '0'i;   @._= +1;   end  /*i*/
               do i=10  to 99;   parse var i  a 2 b;     if a>b  then              @.i= -1
                                                                 else if a<b  then @.i= +1
               end   /*i*/;      #= 0;        $=;        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: say 'the first '   commas(#)   " numbers are:";   say;       w= length( word($, #) )
      _=;    do o=1  for n;     _= _ right( word($, o), w);    if o//20\==0  then iterate
             say substr(_, 2);  _=               /*display a line;  nullify a new line. */
             end   /*o*/                         /* [↑]  display  20  numbers to a line.*/

      if _\==''  then say substr(_, 2);   return /*handle any residual numbers in list. */
