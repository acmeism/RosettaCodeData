/*REXX program  calculates and displays  the first   N   perfect totient  numbers.      */
parse arg N .                                    /*obtain optional argument from the CL.*/
if N==''  |  N==","  then N= 20                  /*Not specified?  Then use the default.*/
@.= .                                            /*memoization array of totient numbers.*/
p= 0                                             /*the count of perfect    "       "    */
$=                                               /*list of the     "       "       "    */
     do j=3  by 2  until p==N                    /*obtain the totient number for index J*/
     if j//3\==0   then  if j//5\==0   then  if j//7\==0   then iterate
     s= phi(j);  a= s                            /* [↑]  J  must have 1 of these factors*/
                               do until a==1;  if @.a==.  then a= phi(a);    else a= @.a
                                               s= s + a
                               end   /*until*/
     if s\==j  then iterate                      /*Is  J  not a perfect totient number? */
     p= p + 1                                    /*bump count of perfect totient numbers*/
     $= $ j                                      /*add to perfect totient numbers list. */
     end   /*j*/

say 'The first '  N  " perfect totient numbers:" /*display the header to the terminal.  */
say strip($)                                     /*   "     "  list.   "  "     "       */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gcd: parse arg x,y;   do  until y==0;  parse value  x//y  y   with   y  x;  end;  return x
/*──────────────────────────────────────────────────────────────────────────────────────*/
phi: procedure expose @.; parse arg z;   if @.z\==.  then return @.z /*was found before?*/
     #= z==1;         do m=1  for z-1;   if gcd(m, z)==1  then #= # + 1;    end  /*m*/
     @.z= #;   return #                                              /*use memoization. */
