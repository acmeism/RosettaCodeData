/*REXX program computes powers of two whose leading decimal digits are "12" (in base 10)*/
parse arg L n b .                                /*obtain optional arguments from the CL*/
if L=='' | L=="," then L= 12                     /*Not specified?  Then use the default.*/
if n=='' | n=="," then n=  1                     /* "      "         "   "   "     "    */
if b=='' | b=="," then b=  2                     /* "      "         "   "   "     "    */
LL= length(L)                                    /*obtain the length of  L  for compares*/
fd=   left(L, 1)                                 /*obtain the first   dec. digit  of  L.*/
fr= substr(L, 2)                                 /*   "    "  rest of dec. digits  "  " */
numeric digits max(20, LL+2)                     /*use an appropriate value of dec. digs*/
rest= LL - 1                                     /*the length of the rest of the digits.*/
#= 0                                             /*the number of occurrences of a result*/
x= 1                                             /*start with a product of unity (B**0).*/
     do j=1  until #==n;        x= x * b         /*raise  B  to a whole bunch of powers.*/
     parse var x _ 2                             /*obtain the first decimal digit of  X.*/
     if _ \== fd  then iterate                   /*check only the 1st digit at this time*/
     if LL>1  then do                            /*check the rest of the digits, maybe. */
                   $= format(x, , , , 0)         /*express  X  in exponential format.   */
                   parse var $ '.' +1 f +(rest)  /*obtain the rest of the digits.       */
                   if f \== fr  then iterate     /*verify that  X  has the rest of digs.*/
                   end                           /* [↓] found an occurrence of an answer*/
     #= # + 1                                    /*bump the number of occurrences so far*/
     end   /*j*/

say 'The '  th(n)  ' occurrence of '   b  ' raised to a power whose product starts with' ,
                                                  ' "'L"'"       ' is '        commas(j).
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: arg _;     do c=length(_)-3  to 1  by -3;  _= insert(',', _, c);  end;    return _
th:     arg _;  return _ || word('th st nd rd', 1 +_//10 * (_//100 % 10\==1) * (_//10 <4))
