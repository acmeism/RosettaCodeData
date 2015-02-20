/*REXX program calculates  Carmichael  3-strong  pseudoprimes (up to N).*/
numeric digits 30                      /*in case user wants bigger nums.*/
parse arg N .;    if N==''  then N=61  /*allow user to specify the limit*/
if 7=='f7'x  then times='af'x          /*if EBCDIC machine, use a bullet*/
             else times='f9'x          /* " ASCII     "      "  "   "   */
carms=0                                /*number of Carmichael #s so far.*/
!.=0;   !.2=1; !.3=1; !.5=1; !.7=1; !.11=1; !.13=1; !.17=1; !.19=1; !.23=1
                                       /*[↓]  prime # memoization array.*/
    do p=3  to N  by 2;  if \isPrime(p)  then iterate  /*Not prime? Skip*/
    pm=p-1;  nps=-p*p;   bot=0;  top=0 /*some handy-dandy REXX variables*/
    @.=0                               /*[↑]  Carmichael numbers are odd*/
             do h3=2  to  pm;  g=h3+p  /*find Carmichael #s for this P. */
             gPM=g*pm;         npsH3=((nps//h3)+h3)//h3     /*shortcuts.*/

                do d=1  for g-1
                if gPM//d  \==  0              then iterate
                if npsH3   \==  d//h3          then iterate
                q=1+gPM%d;     if \isPrime(q)  then iterate
                r=1+p*q%h3;    if q*r//pm\==1  then iterate
                               if \isPrime(r)  then iterate
                carms=carms+1; @.q=r   /*bump Carmichael #; add to array*/
                if bot==0  then bot=q;   bot=min(bot,q);    top=max(top,q)
   /*find the maximum.              */
                end   /*d*/            /* [↑]  find minimum and maximum.*/
             end      /*h3*/
    $=0                                /*display a list of some Carm #s.*/
         do j=bot  to top  by 2;       if @.j==0  then iterate;        $=1
         say '──────── a Carmichael number: '   p   times  j   times   @.j
         end   /*j*/
    if $  then say                     /*show beautification blank line.*/
    end        /*p*/

say;     say carms ' Carmichael numbers found.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPRIME subroutine──────────────────*/
isPrime: procedure expose !.;     parse arg x;   if !.x      then return 1
if x<23 then return 0; if x//2==0 then return 0; if x// 3==0 then return 0
if right(x,1)==5 then return 0;                  if x// 7==0 then return 0
if x//11==0      then return 0;                  if x//13==0 then return 0
if x//17==0      then return 0;                  if x//19==0 then return 0
                   do i=23 by 6  until i*i>x; if x// i   ==0 then return 0
                                              if x//(i+2)==0 then return 0
                   end  /*i*/
!.x=1;  return 1
