/*REXX program returns the 3 middle digits of a number  (or an error).  */
n ='123 12345 1234567 987654321 10001 -10001 -123 -100 100 -12345',
   '2 -1 -10 2002 -2002 0 abc 1e3 -17e-3 1234567. 1237654.00',
   '1234567890123456789012345678901234567890123456789012345678901234567'

     do j=1  for words(n); z=word(n,j) /* [↓]  format the output nicely.*/
     say 'middle 3 digits of'  right(z,max(15,length(z))) '──►' middle3(z)
     end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MIDDLE3 subroutine──────────────────*/
middle3: procedure;  arg x;   numeric digits 1e5;   er='    ***error!*** '
if datatype(x,'N')   then x=abs(x);                 L=length(x)
if \datatype(x,'W')  then return  er  "arg isn't an integer"
if L<3               then return  er  "arg is less than three digits"
if L//2==0           then return  er  "arg isn't an odd number of digits"
                          return  substr(x, (L-3)%2+1, 3)
