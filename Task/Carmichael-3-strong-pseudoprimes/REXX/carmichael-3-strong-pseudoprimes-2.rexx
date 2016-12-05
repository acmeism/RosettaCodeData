/*REXX program calculates  Carmichael  3─strong  pseudoprimes  (up to and including N). */
numeric digits 18                                /*handle big dig #s (9 is the default).*/
parse arg N .;    if N==''  then N=61            /*allow user to specify for the search.*/
tell= N>0;           N=abs(N)                    /*N>0?  Then display Carmichael numbers*/
#=0;              @.=0                           /*number of Carmichael numbers so far. */
@.2=1; @.3=1; @.5=1; @.7=1; @.11=1; @.13=1; @.17=1; @.19=1; @.23=1; @.29=1; @.31=1; @.37=1
HP=37;     do i=HP+2  by 2  for N*20;  if isPrime(i)  then do; @.i=1; HP=i; end; end /*i*/
HP=HP+2
                                                 /*[↑]  prime number memoization array. */
    do p=3  to N  by 2;  pm=p-1;   bot=0;  top=0 /*step through some (odd) prime numbers*/
    if \isPrime(p)  then iterate;  nps=-p*p      /*is   P   a prime?   No, then skip it.*/
    !.=0                                         /*the list of Carmichael #'s  (so far).*/
             do h3=2  to  pm;  g=h3+p            /*find Carmichael #s  for this prime.  */
             gPM=g*pm;  npsH3=((nps//h3)+h3)//h3 /*define a couple of shortcuts for pgm.*/
                                                 /* [↓] perform some weeding of D values*/
                 do d=1  for g-1;                   if gPM//d \== 0      then iterate
                                                    if npsH3  \== d//h3  then iterate
                                       q=1+gPM%d;   if \isPrime(q)       then iterate
                                       r=1+p*q%h3;  if q*r//pm\==1       then iterate
                                                    if \isPrime(r)       then iterate
                 #=#+1;                !.q=r     /*bump Carmichael counter; add to array*/
                 if bot==0  then bot=q;   bot=min(bot,q);    top=max(top,q)
                 end   /*d*/
             end       /*h3*/
    $=                                           /*display a list of some Carmichael #s.*/
             do j=bot  to top  by 2  while tell;   if !.j\==0  then $=$  p"∙"j'∙'!.j
             end           /*j*/

    if $\==''  then say 'Carmichael number: '      strip($)
    end                /*p*/
say
say '──────── '     #     " Carmichael numbers found."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: parse arg x;             if @.x      then return 1           /*X a known prime?*/
         if x<HP  then return 0;  if x//2==0  then return 0; if x// 3==0     then return 0
         parse var x '' -1 _;     if _==5     then return 0; if x// 7==0     then return 0
         if x//11==0      then return 0;                     if x//13==0     then return 0
         if x//17==0      then return 0;                     if x//19==0     then return 0
         if x//23==0      then return 0;                     if x//29==0     then return 0
         if x//31==0      then return 0;                     if x//37==0     then return 0
c=x                                              /*                                  ___*/
b=1;   do  while b<=x;  b=b*4;  end              /*these two lines compute integer  √ X */
s=0;   do  while b>1;   b=b%4;  _=c-s-b;  s=s%2;   if _>=0  then do; c=_; s=s+b; end;  end
                                do k=41  by 6  to s;               parse var  k  ''  -1  _
                                if _\==5  then               if x// k   ==0  then return 0
                                if _\==3  then               if x//(k+2)==0  then return 0
                                end  /*k*/       /*K   will never be divisible by three.*/
         @.x=1;   return 1                       /*Define a new prime (X).  Indicate so.*/
