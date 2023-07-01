/*REXX program lists a sequence  (or a count)  of  ──strong──   or   ──weak──   primes. */
parse arg N kind _ . 1 . okind;     upper kind   /*obtain optional arguments from the CL*/
if N=='' | N==","  then N= 36                    /*Not specified?   Then assume default.*/
if kind=='' | kind==","  then kind= 'STRONG'     /* "      "          "     "      "    */
if _\==''                             then call ser 'too many arguments specified.'
if kind\=='WEAK'  &  kind\=='STRONG'  then call ser 'invalid 2nd argument: '   okind
if kind =='WEAK'  then weak= 1;  else weak= 0    /*WEAK  is a binary value for function.*/
w = linesize() - 1                               /*obtain the usable width of the term. */
tell= (N>0);    @.=;    N= abs(N)                /*N is negative?   Then don't display. */
!.=0;   !.1=2;  !.2=3;  !.3=5;  !.4=7;  !.5=11;  !.6=13;  !.7=17;  !.8=19;   !.9=23;  #= 8
@.='';  @.2=1;  @.3=1;  @.5=1;  @.7=1;  @.11=1;  @.13=1;  @.17=1;  @.19=1;   start= # + 1
m= 0;                           lim= 0           /*#  is the number of low primes so far*/
$=;     do i=3  for #-2   while lim<=N           /* [↓]  find primes, and maybe show 'em*/
        call strongWeak i-1;       $= strip($)   /*go see if other part of a KIND prime.*/
        end   /*i*/                              /* [↑]  allows faster loop (below).    */
                                                 /* [↓]  N:  default lists up to 35 #'s.*/
   do j=!.#+2  by 2  while  lim<N                /*continue on with the next odd prime. */
   if j // 3 == 0  then iterate                  /*is this integer a multiple of three? */
   parse var  j    ''  -1  _                     /*obtain the last decimal digit of  J  */
   if _      == 5  then iterate                  /*is this integer a multiple of five?  */
   if j // 7 == 0  then iterate                  /* "   "     "    "     "     " seven? */
   if j //11 == 0  then iterate                  /* "   "     "    "     "     " eleven?*/
   if j //13 == 0  then iterate                  /* "   "     "    "     "     "  13 ?  */
   if j //17 == 0  then iterate                  /* "   "     "    "     "     "  17 ?  */
   if j //19 == 0  then iterate                  /* "   "     "    "     "     "  19 ?  */
                                                 /* [↓]  divide by the primes.   ___    */
            do k=start  to #  while !.k * !.k<=j /*divide  J  by other primes ≤ √ J     */
            if j // !.k ==0   then iterate j     /*÷ by prev. prime?  ¬prime     ___    */
            end   /*k*/                          /* [↑]   only divide up to     √ J     */
   #= # + 1                                      /*bump the count of number of primes.  */
   !.#= j;                     @.j= 1            /*define a prime  and  its index value.*/
   call strongWeak #-1                           /*go see if other part of a KIND prime.*/
   end   /*j*/
                                                 /* [↓]  display number of primes found.*/
if $\==''  then say $                            /*display any residual primes in $ list*/
say
if tell  then say commas(m)' '     kind    "primes found."
         else say commas(m)' '     kind    "primes found below or equal to "    commas(N).
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
add: m= m+1; lim= m; if \tell & y>N  then do; lim= y; m= m-1; end; else call app; return 1
app: if tell  then if length($ y)>w  then do;  say $; $= y;   end; else $= $ y;   return 1
ser: say;  say;  say '***error***' arg(1);  say;  say;  exit 13   /*tell error message. */
commas: parse arg _;  do jc=length(_)-3  to 1  by -3; _=insert(',', _, jc); end;  return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
strongWeak: parse arg x;  Lp= x - 1;     Hp= x + 1;     y=!.x;        s= (!.Lp + !.Hp) / 2
            if weak  then if y<s  then return add()               /*is  a    weak prime.*/
                                  else return 0                   /*not "      "    "   */
                     else if y>s  then return add()               /*is  an strong prime.*/
                                       return 0                   /*not  "   "      "   */
