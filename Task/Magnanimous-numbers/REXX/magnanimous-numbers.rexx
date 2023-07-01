/*REXX pgm finds/displays magnanimous #s  (#s with a inserted + sign to sum to a prime).*/
parse arg bet.1 bet.2 bet.3 highP .              /*obtain optional arguments from the CL*/
if bet.1=='' | bet.1==","  then bet.1=   1..45   /* "      "         "   "   "     "    */
if bet.2=='' | bet.2==","  then bet.2= 241..250  /* "      "         "   "   "     "    */
if bet.3=='' | bet.3==","  then bet.3= 391..400  /* "      "         "   "   "     "    */
if highP=='' | highP==","  then highP=  1000000  /* "      "         "   "   "     "    */
call genP                                        /*gen primes up to  highP  (1 million).*/

     do j=1  for 3                               /*process three magnanimous "ranges".  */
     parse var   bet.j   LO  '..'  HI            /*obtain the first range (if any).     */
     if HI==''  then HI= LO                      /*Just a single number?   Then use LO. */
     if HI==0   then iterate                     /*Is HI a zero?   Then skip this range.*/
     finds= 0;                             $=    /*#:  magnanimous # cnt;  $:  is a list*/
                do k=0  until finds==HI          /* [↓]  traipse through the number(s). */
                if \magna(k)  then iterate       /*Not magnanimous?  Then skip this num.*/
                finds= finds + 1                 /*bump the magnanimous number count.   */
                if finds>=LO  then $= $ k        /*In range►  Then add number ──► $ list*/
                end   /*k*/
     say
     say center(' 'LO       "──►"       HI       'magnanimous numbers ',  126, "─")
     say strip($)
     end        /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
magna: procedure expose @. !.; parse arg x 1 L 2 '' -1 R  /*obtain #,  1st & last digit.*/
       len= length(x);       if len==1  then return 1     /*one digit #s are magnanimous*/
       if x>1001  then if L//2 == R//2  then return 0     /*Has parity?  Not magnanimous*/
                do  s= 1  for  len-1                      /*traipse thru #, inserting + */
                parse var  x   y  +(s)  z;   sum= y + z   /*parse 2 parts of #, sum 'em.*/
                if !.sum  then iterate                    /*Is sum prime? So far so good*/
                          else return 0                   /*Nope?  Then not magnanimous.*/
                end   /*s*/
       return 1                                  /*Pass all the tests, it's magnanimous.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: @.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13   /*assign low primes; # primes.*/
      !.= 0; !.2=1; !.3=1; !.5=1; !.7=1; !.11=1; !.13=1   /*   "   semaphores to   "    */
                           #= 6;  sq.#= @.# ** 2          /*# primes so far;  P squared.*/
        do j=@.#+4  by 2  to highP; parse var j '' -1 _; if _==5  then iterate /*÷ by 5?*/
        if j// 3==0  then iterate;   if j// 7==0  then iterate    /*÷ by 3?;     ÷ by 7?*/
        if j//11==0  then iterate                                 /*"  " 11?     " " 13?*/
                do k=6  while sq.k<=j            /*divide by some generated odd primes. */
                if j//@.k==0  then iterate j     /*Is J divisible by  P?  Then not prime*/
                end   /*k*/                      /* [↓]  a prime  (J)  has been found.  */
        #= #+1;   @.#= j;   sq.#= j*j;   !.j= 1  /*bump #Ps; P──►@.assign P; P^2; P flag*/
        end     /*j*/;                 return
