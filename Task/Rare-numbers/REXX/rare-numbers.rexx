/*REXX program  calculates and displays  a  specified amount of   rare    numbers.      */
numeric digits 20;    w= digits() + digits() % 3 /*use enough dec. digs for calculations*/
parse arg many .                                 /*obtain optional argument from the CL.*/
if  many=='' |  many==","  then  many= 5         /*Not specified?  Then use the default.*/
@g= 2002 2112 2222 2332 2442 2552 2662 2772 2882 2992 4000 4010 4030 4050 4070 4090 4100 ,
    4110 4120 4140 4160 4180 4210 4230 4250 4270 4290 4300 4320 4340 4360 4380 4410 4430 ,
    4440 4450 4470 4490 4500 4520 4540 4560 4580 4610 4630 4650 4670 4690 4700 4720 4740 ,
    4760 4780 4810 4830 4850 4870 4890 4900 4920 4940 4960 4980 4990 6010 6015 6030 6035 ,
    6050 6055 6070 6075 6090 6095 6100 6105 6120 6125 6140 6145 6160 6165 6180 6185 6210 ,
    6215 6230 6235 6250 6255 6270 6275 6290 6295 6300 6305 6320 6325 6340 6345 6360 6365 ,
    6380 6385 6410 6415 6430 6435 6450 6455 6470 6475 6490 6495 6500 6505 6520 6525 6540 ,
    6545 6560 6565 6580 6585 6610 6615 6630 6635 6650 6655 6670 6675 6690 6695 6700 6705 ,
    6720 6725 6740 6745 6760 6765 6780 6785 6810 6815 6830 6835 6850 6855 6870 6875 6890 ,
    6895 6900 6905 6920 6925 6940 6945 6960 6965 6980 6985 8007 8008 8017 8027 8037 8047 ,
    8057 8067 8077 8087 8092 8097 8107 8117 8118 8127 8137 8147 8157 8167 8177 8182 8187 ,
    8197 8228 8272 8297 8338 8362 8387 8448 8452 8477 8542 8558 8567 8632 8657 8668 8722 ,
    8747 8778 8812 8837 8888 8902 8927 8998      /*4 digit abutted numbers for AB and PQ*/
@g#= words(@g)
         /* [↓]─────────────────boolean arrays are used for checking for digit presence.*/
@dr.=0;   @dr.2= 1; @dr.5=1 ; @dr.8= 1; @dr.9= 1 /*rare # must have these digital roots.*/
@ps.=0;   @ps.2= 1; @ps.3= 1; @ps.7= 1; @ps.8= 1 /*perfect squares    must end in these.*/
@149.=0;  @149.1=1; @149.4=1; @149.9=1           /*values for  Z  that need an even  Y. */
@odd.=0;  do i=-9  by 2  to 9;   @odd.i=1        /*   "    "   N    "    "   "   "   A. */
          end   /*i*/
@gen.=0;  do i=1  for words(@g); parse value word(@g,i) with a 2 b 3 p 4 q; @gen.a.b.p.q=1
               /*# AB···PQ  could be a good rare value*/
          end   /*i*/
div9= 9                                          /*dif must be ÷ 9 when N has even #digs*/
evenN= \ (10 // 2)                               /*initial value for evenness of  N.    */
#= 0                                             /*the number of  rare  numbers (so far)*/
    do n=10                                      /*Why 10?  All 1 dig #s are palindromic*/
    parse var   n   a  2  b  3  ''  -2  p  +1  q /*get 1st\2nd\penultimate\last digits. */
    if @odd.a  then do;  n=n+10**(length(n)-1)-1 /*bump N so next N starts with even dig*/
                         evenN=\(length(n+1)//2) /*flag when N has an even # of digits. */
                         if evenN  then div9=  9 /*when dif isn't divisible by   9  ... */
                                   else div9= 99 /*  "   "    "        "     "  99   "  */
                         iterate                 /*let REXX do its thing with  DO  loop.*/
                    end                          /* {it's allowed to modify a DO index} */
    if \@gen.a.b.p.q  then iterate               /*can  N  not be a rare AB···PQ number?*/
    r= reverse(n)                                /*obtain the reverse of the number  N. */
    if r>n   then iterate                        /*Difference will be negative?  Skip it*/
    if n==r  then iterate                        /*Palindromic?   Then it can't be rare.*/
    dif= n-r;   parse var  dif  ''  -2  y  +1  z /*obtain the last 2 digs of difference.*/
    if @ps.z  then iterate                       /*Not 0, 1, 4, 5, 6, 9? Not perfect sq.*/
       select
       when z==0   then if y\==0    then iterate /*Does Z = 0?   Then  Y  must be zero. */
       when z==5   then if y\==2    then iterate /*Does Z = 5?   Then  Y  must be two.  */
       when z==6   then if y//2==0  then iterate /*Does Z = 6?   Then  Y  must be odd.  */
       otherwise        if @149.z   then if y//2  then iterate /*Z=1,4,9? Y must be even*/
       end   /*select*/                          /* [↑]  the OTHERWISE handles Z=8 case.*/
    if dif//div9\==0  then iterate               /*Difference isn't ÷ by div9? Then skip*/
    sum= n+r;   parse var  sum  ''  -2  y  +1  z /*obtain the last two digits of the sum*/
    if @ps.z  then iterate                       /*Not 0, 2, 5, 8, or 9? Not perfect sq.*/
       select
       when z==0   then if y\==0    then iterate /*Does Z = 0?   Then  Y  must be zero. */
       when z==5   then if y\==2    then iterate /*Does Z = 5?   Then  Y  must be two.  */
       when z==6   then if y//2==0  then iterate /*Does Z = 6?   Then  Y  must be odd.  */
       otherwise        if @149.z   then if y//2  then iterate /*Z=1,4,9? Y must be even*/
       end   /*select*/                          /* [↑]  the OTHERWISE handles Z=8 case.*/
    if evenN  then if sum//11 \==0  then iterate /*N has even #digs? Sum must be ÷ by 11*/
    $= a + b                                     /*a head start on figuring digital root*/
                       do k=3  for length(n) - 2 /*now, process the rest of the digits. */
                       $= $ + substr(n, k, 1)    /*add the remainder of the digits in N.*/
                       end   /*k*/
       do while $>9                              /* [◄]  Algorithm is good for 111 digs.*/
       if $>9  then $= left($,1) + substr($,2,1) + substr($,3,1,0)     /*>9?  Reduce it.*/
       end   /*while*/
    if \@dr.$                 then iterate       /*Doesn't have good digital root?  Skip*/
    if iSqrt(sum)**2 \== sum  then iterate       /*Not a perfect square?  Then skip it. */
    if iSqrt(dif)**2 \== dif  then iterate       /* "  "    "       "       "    "   "  */
    #= # + 1;                 call tell          /*bump rare number counter;  display #.*/
    if #>=many  then leave                       /* [↑]  W:  the width of # with commas.*/
    end   /*n*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do jc=length(_)-3  to 1  by -3; _=insert(',', _, jc); end;  return _
tell:   say right(th(#),length(#)+9)  ' rare number is:'  right(commas(n),w);     return
th:     parse arg th;return th||word('th st nd rd',1+(th//10)*(th//100%10\==1)*(th//10<4))
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt:  parse arg x;    $= 0;  q= 1;                             do while q<=x; q=q*4; end
          do while q>1; q=q%4; _= x-$-q;  $= $%2;  if _>=0  then do;      x=_;  $=$+q; end
          end   /*while q>1*/;                     return $
