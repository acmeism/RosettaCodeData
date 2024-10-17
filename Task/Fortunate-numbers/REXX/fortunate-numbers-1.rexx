/*REXX program finds/displays fortunate numbers  N,  where  N  is specified (default=8).*/
numeric digits 12
parse arg n cols .                               /*obtain optional argument from the CL.*/
if    n=='' |    n==","  then    n=  8           /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols= 10           /* "      "         "   "   "     "    */
call genP n**2                                   /*build array of semaphores for primes.*/
pp.= 1
      do i=1  for n+1;   im= i - 1;    pp.i= pp.im * @.i   /*calculate primorial numbers*/
      end   /*i*/
i=i-1;  call genp pp.i + 1000
                     title= ' fortunate numbers'
w= 10                                            /*maximum width of a number in any col.*/
say ' index │'center(title, 1 + cols*(w+1)     )
say '───────┼'center(""   , 1 + cols*(w+1), '─')
found= 0;                           idx= 1       /*number of fortunate (so far) & index.*/
!!.= 0;                             maxFN= 0     /*(stemmed)  array of fortunate numbers*/
        do j=1  until found==n;     pt= pp.j     /*search for fortunate numbers in range*/
        pt= pp.j                                 /*get the precalculated primorial prime*/
                     do m=3  by 2;  t= pt + m    /*find  M  that satisfies requirement. */
                     if !.t==''  then leave      /*Is !.t prime?  Then we found a good M*/
                     end   /*m*/
        if !!.m  then iterate                    /*Fortunate # already found?  Then skip*/
        !!.m= 1;      found= found + 1           /*assign fortunate number;  bump count.*/
        maxFN= max(maxFN, t)                     /*obtain max fortunate # for displaying*/
        end   /*j*/
$=;                                 finds= 0     /*$:  line of output;    FINDS:  count.*/
      do k=1  for maxFN;  if \!!.k  then iterate /*show the fortunate numbers we found. */
      finds= finds + 1                           /*bump the  count of numbers (for $).  */
      c= commas(k)                               /*maybe add commas to the number.      */
      $= $  right(c, max(w, length(c) ) )        /*add a nice prime ──► list, allow big#*/
      if found//cols\==0  then iterate           /*have we populated a line of output?  */
      say center(idx, 7)'│'  substr($, 2);   $=  /*display what we have so far  (cols). */
      idx= idx + cols                            /*bump the  index  count for the output*/
      end   /*k*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
say '───────┴'center(""   , 1 + cols*(w+1), '─')     /*display the foot separator.      */
say
say 'Found '       commas(found)      title
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP:        @.1=2; @.2=3; @.3=5; @.4=7;  @.5=11 /*define some low primes.              */
      !.=0;  !.2=;  !.3=;  !.5=;  !.7=;   !.11=  /*   "     "   "    "     semaphores.  */
                           #= 5;  sq.#= @.#**2   /*squares of low primes.*/
        do j=@.#+2  by 2  to arg(1)              /*find odd primes from here on.        */
        parse var j '' -1 _;     if _==5  then iterate       /*J ÷ by 5 ?               */
        if j//3==0  then iterate;  if j//7==0  then iterate  /*" "  " 3?;    J ÷ by 7 ? */
               do k=5  while sq.k<=j             /* [↓]  divide by the known odd primes.*/
               if j // @.k == 0  then iterate j  /*Is  J ÷ X?  Then not prime.     ___  */
               end   /*k*/                       /* [↑]  only process numbers  ≤  √ J   */
        #= #+1;    @.#= j;    sq.#= j*j;  !.j=   /*bump # of Ps; assign next P;  P²; P# */
        end          /*j*/;               return
