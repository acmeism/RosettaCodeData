/*REXX pgm, Josephus problem: N men standing in a circle, every Kth kilt*/
parse arg N K Z R .                    /*get optional arguments.        */
if N==',' | N==''   then  N = 41       /*no #prisoners? Then use default*/
if K==',' | K==''   then  K =  3       /*no kill count?   "   "     "   */
if Z==',' | Z==''   then  Z =  0       /*no initial # ?   "   "     "   */
if R==',' | R==''   then  R =  1       /*no remaining#?   "   "     "   */
$=; x=;  do pop=Z for N;  $=$ pop; end /*populate the prisoner's circle.*/
c=0                                    /*initial prisoner count-off num.*/
    do remove=0;   p=words($)          /*keep removing until R are left.*/
    c=c+K                              /*bump prisoner  count-off  by K.*/
    if c>p then do                     /*   [↓] remove some prisoner(s).*/
                  do j=1  for words(x);   $=delword($,word(x,j)+1-j,1)
                  if words($)==R  then leave remove  /*slaying done yet?*/
                  end   /*j*/
                c=(c//p)//words($); x= /*adjust prisoner count-off &list*/
                end
    if c\==0  then x=x c               /*list of prisoners to be removed*/
    end   /*remove*/                   /*remove 'til  R  prisoners left.*/

say 'removing every ' th(K) " prisoner out of " N ' (starting at' Z")  with ",
    R ' survivor's(R)"," ;             say 'leaving prisoner's(R)':' $
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines──────────────────────────*/
s:  if arg(1)==1  then return arg(3);   return word(arg(2) 's',1)
th: arg y; return y||word('th st nd rd', 1+y//10*(y//100%10\==1)*(y//10<4))
