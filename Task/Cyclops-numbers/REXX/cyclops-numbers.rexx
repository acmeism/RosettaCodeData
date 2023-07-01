/*REXX pgm finds 1st N cyclops (Θ) #s,  Θ primes,  blind Θ primes,  palindromic Θ primes*/
parse arg n cols .                               /*obtain optional argument from the CL.*/
if    n=='' |    n==","  then    n=   50         /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=   10         /* "      "         "   "   "     "    */
call genP                                        /*build array of semaphores for primes.*/
w= max(10, length( commas(@.#) ) )               /*max width of a number in any column. */
pri?= 0; bli?= 0; pal?= 0; call 0 ' first ' commas(n)                   " cyclops numbers"
pri?= 1; bli?= 0; pal?= 0; call 0 ' first ' commas(n)             " prime cyclops numbers"
pri?= 1; bli?= 1; pal?= 0; call 0 ' first ' commas(n)       " blind prime cyclops numbers"
pri?= 1; bli?= 0; pal?= 1; call 0 ' first ' commas(n) " palindromic prime cyclops numbers"
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
0: parse arg title;                idx= 1        /*get the title of this output section.*/
   say ' index │'center(title,   1 + cols*(w+1)     )      /*display the output title.  */
   say '───────┼'center(""   ,   1 + cols*(w+1), '─')      /*   "     "     "  separator*/
                   finds= 0;                 $=  /*the number of finds (so far); $ list.*/
     do j=0  until finds== n;      L= length(j)  /*find N cyclops numbers, start at 101.*/
     if L//2==0  then do;    j= left(1, L+1, 0)  /*Is J an even # of digits? Yes, bump J*/
                                        iterate  /*use a new J that has odd # of digits.*/
                      end
     z= pos(0, j);  if z\==(L+1)%2 then iterate  /* "  "    "    " (zero in mid)?    "  */
     if pos(0, j, z+1)>0           then iterate  /* "  "    "    " (has two 0's)?    "  */
     if pri?  then if \!.j         then iterate  /*Need a cyclops prime?      Then skip.*/
     if bli?  then do;   ?= space(translate(j, , 0), 0)   /*Need a blind cyclops prime ?*/
                         if \!.?   then iterate  /*Not a blind cyclops prime? Then skip.*/
                   end
     if pal?  then do;   r= reverse(j)           /*Need a palindromic cyclops prime?    */
                         if r\==j  then iterate  /*Cyclops number not palindromic? Skip.*/
                         if \!.r   then iterate  /*   "    palindrome not prime?     "  */
                   end
     finds= finds + 1                            /*bump the number of palindromic primes*/
     $= $ right( commas(j), w)                   /*add a palindromic prime ──►  $  list.*/
     if finds//cols\==0            then iterate  /*have we populated a line of output?  */
     say center(idx, 7)'│'  substr($, 2);    $=  /*display what we have so far  (cols). */
     idx= idx + cols                             /*bump the  index  count for the output*/
     end   /*j*/
   if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible show residual output.*/
   say '───────┴'center(""  ,   1 + cols*(w+1), '─');  say
   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: !.= 0;  hip= 7890987 - 1                   /*placeholders for primes (semaphores).*/
      @.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13 /*define some low primes.              */
      !.2=1; !.3=1; !.5=1; !.7=1; !.11=1; !.13=1 /*   "     "   "    "     flags.       */
                        #= 6;     sq.#= @.# ** 2 /*number of primes so far; prime square*/
        do j=@.#+2  by 2  for max(0, hip%2-@.#%2-1)     /*find odd primes from here on. */
        parse var   j   ''  -1  _                       /*get the last dec. digit of  J.*/
        if     _==5  then iterate;  if j// 3==0  then iterate  /*÷ by 5?  ÷ by 3?  Skip.*/
        if j// 7==0  then iterate;  if j//11==0  then iterate  /*÷  " 7?  ÷ by 11?   "  */
               do k=6  while sq.k<=j             /* [↓]  divide by the known odd primes.*/
               if j // @.k == 0  then iterate j  /*Is  J ÷ X?  Then not prime.     ___  */
               end   /*k*/                       /* [↑]  only process numbers  ≤  √ J   */
        #= #+1;    @.#= j;   sq.#= j*j;   !.j= 1 /*bump # Ps;  assign next P;  P sq; P# */
        end          /*j*/;               return
