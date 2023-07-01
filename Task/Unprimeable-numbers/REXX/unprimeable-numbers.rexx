/*REXX program  finds and displays   unprimeable   numbers  (non─negative integers).    */
parse arg n x hp .                               /*obtain optional arguments from the CL*/
if  n=='' |  n==","  then  n=       35           /*Not specified?  Then use the default.*/
if  x=='' |  x==","  then  x=      600           /* "      "         "   "   "     "    */
if hp=='' | hp==","  then hp= 10000000           /* "      "         "   "   "     "    */
u= 0                                             /*number of unprimeable numbers so far.*/
eds=4;     ed.1= 1;  ed.2= 3;  ed.3= 7;  ed.4= 9 /*"end" digits which are prime; prime>9*/
call genP hp                                     /*generate primes up to & including HP.*/
$$=;                       $.=.                  /*a list  "      "         "     "  "  */
      do j=100;            if !.j  then iterate  /*Prime?  Unprimeable must be composite*/
      Lm= length(j)                              /*obtain the length-1 of the number J. */
      meat= left(j, Lm)                          /*obtain the first  Lm   digits of  J. */
                                                 /* [↑]  examine the "end" digit of  J. */
        do e_=1  for eds;  new= meat || ed.e_    /*obtain a different number  (than  J).*/
        if new==j  then iterate                  /*Is it the original number? Then skip.*/
        if !.new   then iterate j                /*This new number a prime?     "    "  */
        end  /*e_*/
                                                 /* [↑]  examine a new 1st digit of  J. */
        do f_=0  for 10;   new= (f_||meat) + 0   /*obtain a different number  (than  J).*/
        if new==j  then iterate                  /*Is it the original number? Then skip.*/
        if !.new   then iterate j                /*This new number a prime?     "    "  */
        end  /*f_*/                              /* [↑]  examine the front digit of  J. */
                    do a_= 2  for Lm-1           /*traipse through the middle digits.   */
                    meat=   left(j, a_ - 1)      /*use a number of left─most dec. digits*/
                    rest= substr(j, a_ + 1)      /* "  "    "    " right─most "     "   */
                       do n_=0  for 10           /*traipse through all 1─digit numbers. */
                       new= meat || n_ || rest   /*construct new number, like a phoenix.*/
                       if new==j  then iterate   /*Is it the original number? Then skip.*/
                       if !.new   then iterate j /*This new number a prime?     "    "  */
                       end   /*n_*/
                    end      /*a_*/
      u= u + 1                                   /*bump the count of unprimeable numbers*/
      if u<=n    then $$= $$ commas(j)           /*maybe add unprimeable # to  $$  list.*/
      if u==x    then $.ox=  commas(j)           /*assign the   Xth  unprimeable number.*/
      parse var   j     ''  -1  _                /*obtain the right─most dec digit of J.*/
      if $._==.  then $._= j                     /*the 1st unprimeable # that ends in _.*/
      if $.3==.  then iterate;  if $.7==.  then iterate    /*test if specific #'s found.*/
      if $.1==.  then iterate;  if $.9==.  then iterate    /*  "   "     "     "    "   */
      leave                                                /*if here,  then we're done. */
      end   /*j*/

if n>0  then do;  say center(' first '       n       "unprimeable numbers ", 139, '═')
                  say strip($$);    say
             end
if x>0  then say '     the '     th(x)       " unprimeable number is: "       $.ox
say
     do o=0  for 10;      if length($.o)==0  then iterate
     say '     the first unprimeable number that ends in '  o  " is:"right(commas($.o),11)
     end   /*o*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg ?;  do c=length(?)-3  to 1  by -3; ?=insert(',', ?, c); end;   return ?
th:procedure;parse arg x;return x||word('th st nd rd',1+(x//10)*(x//100%10\==1)*(x//10<4))
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: @.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13; @.7=17; @.8=19; @.9=23; @.10=29; @.11=31
      !.=0; !.2=1; !.3=1; !.5=1; !.7=1; !.11=1; !.13=1; !.17=1; !.19=1; !.23=1; !.29=1
                           #= 11;  sq.#= @.# **2
                   do lim=100  until lim*lim>=hp /*only keep primes up to the sqrt(hp). */
                   end   /*lim*/                 /* [↑]  find limit for storing primes. */
       do j=@.#+2  by 2  to hp;  parse var j '' -1 _;  if _==5  then iterate   /*÷ by 5?*/
       if j// 3==0  then iterate;   if j// 7==0  then iterate;   if j//11==0  then iterate
       if j//13==0  then iterate;   if j//17==0  then iterate;   if j//19==0  then iterate
       if j//23==0  then iterate;   if j//29==0  then iterate
          do k=11  while sq.k<=j                 /*divide by some generated odd primes. */
          if j//@.k==0  then iterate j           /*Is J divisible by  P?  Then not prime*/
          end   /*k*/                            /* [↓]  a prime  (J)  has been found.  */
       #= #+1;   if #<=lim  then @.#=j;   !.j=1  /*bump prime count; assign prime to @. */
                 sq.#= j*j                       /*calculate square of J for fast WHILE.*/
