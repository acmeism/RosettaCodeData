/*REXX program finds and displays  Wieferich primes  which are under a specified limit N*/
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 5000                  /*Not specified?  Then use the default.*/
numeric digits 3000                              /*bump # of dec. digs for calculation. */
numeric digits max(9, length(2**n) )             /*calculate # of decimal digits needed.*/
call genP                                        /*build array of semaphores for primes.*/
          title= ' Wieferich primes that are  < '   commas(n)    /*title for the output.*/
w= length(title) + 2                             /*width of field for the primes listed.*/
say ' index │'center(title, w)                   /*display the title for the output.    */
say '───────┼'center(""   , w, '─')              /*   "     a   sep   "   "     "       */
found= 0                                         /*initialize number of Wieferich primes*/
         do j=1  to #;    p= @.j                 /*search for Wieferich primes in range.*/
         if (2**(p-1)-1)//p**2\==0  then iterate /*P**2 not evenly divide  2**(P-1) - 1?*/       /* ◄■■■■■■■ the filter.*/
         found= found + 1                        /*bump the counter of Wieferich primes.*/
         say center(found, 7)'│'  center(commas(p), w)    /*display the Wieferich prime.*/
         end   /*j*/

say '───────┴'center(""   , w, '─');   say       /*display a  foot sep  for the output. */
say 'Found '       commas(found)       title     /*   "    "  summary    "   "     "    */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP:        @.1=2; @.2=3; @.3=5; @.4=7; @.5=11  /*define some low primes  (index-1).   */
      !.=0;  !.2=1; !.3=1; !.5=1; !.7=1; !.11=1  /*   "     "   "    "     (semaphores).*/
                           #= 5;  sq.#= @.# ** 2 /*number of primes so far;     prime². */
        do j=@.#+2  by 2  to n-1;  parse var j '' -1 _   /*get right decimal digit of J.*/
        if    _==5  then iterate                               /*J ÷ by 5?    Yes, skip.*/
        if j//3==0  then iterate;  if j//7==0  then iterate    /*" "  " 3?    J ÷ by 7? */
               do k=5  while sq.k<=j             /* [↓]  divide by the known odd primes.*/
               if j//@.k==0  then iterate j      /*Is J ÷ a P?   Then not prime.   ___  */
               end   /*k*/                       /* [↑]  only process numbers  ≤  √ J   */
        #= #+1;    @.#= j;   sq.#= j*j;   !.j= 1 /*bump # Ps; assign next P; P sqare; P.*/
        end          /*j*/;               return
