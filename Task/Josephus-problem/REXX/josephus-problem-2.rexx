/*REXX program solves  Josephus problem:   N  men standing in a circle,  every Kth kilt.*/
                                                 /*N=men, K=kilt, Z=start, R=remaining. */
parse arg N K Z R .                              /*obtain optional arguments from the CL*/
if N=='' | N==","   then  N = 41                 /*Not specified?  Then use the default.*/
if K=='' | K==","   then  K =  3                 /* "      "         "   "   "     "    */
if Z=='' | Z==","   then  Z =  0                 /* "      "         "   "   "     "    */
if R=='' | R==","   then  R =  1                 /* "      "         "   "   "     "    */
$=; x=;  do pop=Z for N;  $=$ pop;  end /*pop*/  /*populate prisoner's circle (with a #)*/
c=0                                              /*initial prisoner  count─off  number. */
    do remove=0 by 0;     p=words($)             /*keep removing until  R  are remaining*/
    c=c+K                                        /*bump the prisoner  count-off  by  K. */
    if c>p then do                               /*   [↓] remove (kill) some prisoner(s)*/
                   do j=1  for words(x);    $=delword($, word(x, j) + 1 - j,   1)
                   if words($)==R  then leave remove             /*is the slaying done?*/
                   end   /*j*/
                c=(c//p) // words($);        x=  /*adjust prisoner count-off and circle.*/
                end
    if c\==0  then x=x c                         /*the list of prisoners to be removed. */
    end   /*remove*/                             /*remove 'til   R   prisoners are left.*/

say 'removing every '   th(K)   " prisoner out of "    N    ' (starting at'   Z")  with ",
                           R    ' survivor's(R)",  leaving prisoner"s(R)':'   $
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:  if arg(1)==1  then return arg(3);            return word( arg(2) 's', 1)
th: y=arg(1);    return y || word('th st nd rd', 1+ y // 10 * (y//100%10\==1) * (y//10<4))
