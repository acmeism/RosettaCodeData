/*REXX program:  Josephus problem: N men standing in a circle, every Kth kilt.*/
parse arg N K Z R .                    /*get the optional arguments from C.L. */
if N==',' | N==''   then  N = 41       /*no  #prisoners?  Then use the default*/
if K==',' | K==''   then  K =  3       /*no  kill count?    "   "   "     "   */
if Z==',' | Z==''   then  Z =  0       /*no  initial # ?    "   "   "     "   */
if R==',' | R==''   then  R =  1       /*no  remaining#?    "   "   "     "   */
$=; x=;  do pop=Z for N;  $=$ pop; end /*populate prisoner's circle (with a #)*/
c=0                                    /*initial prisoner  count─off  number. */
    do remove=0;   p=words($)          /*keep removing until  R  are remaining*/
    c=c+K                              /*bump the prisoner  count-off  by  K. */
    if c>p then do                     /*   [↓] remove (kill) some prisoner(s)*/
                  do j=1  for words(x);   $=delword($,word(x,j)+1-j,1)
                  if words($)==R  then leave remove    /*is the slaying done? */
                  end   /*j*/
                c=(c//p)//words($); x= /*adjust prisoner count-off and circle.*/
                end
    if c\==0  then x=x c               /*the list of prisoners to be removed. */
    end   /*remove*/                   /*remove 'til   R   prisoners are left.*/

say 'removing every '  th(K)  " prisoner out of " N ' (starting at' Z")  with ",
     R ' survivor's(R)",";             say 'leaving prisoner's(R)':'  $
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────subroutines───────────────────────────────*/
s:  if arg(1)==1  then return arg(3);   return word(arg(2) 's',1)
th: parse arg y; return y||word('th st nd rd',1+y//10*(y//100%10\==1)*(y//10<4))
