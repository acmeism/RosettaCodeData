/*REXX program counts/displays the number of additive primes under a specified number N.*/
parse arg n cols .                               /*get optional number of primes to find*/
if    n=='' |    n==","  then    n= 500          /*Not specified?   Then assume default.*/
if cols=='' | cols==","  then cols=  10          /* "      "          "     "       "   */
call genP n                                      /*generate all primes under  N.        */
w= 10                                            /*width of a number in any column.     */
                                     title= " additive primes that are  < "     commas(n)
if cols>0  then say ' index │'center(title,  1 + cols*(w+1) )
if cols>0  then say '───────┼'center(""   ,  1 + cols*(w+1), '─')
found= 0;                  idx= 1                /*initialize # of additive primes & IDX*/
$=                                               /*a list of additive primes  (so far). */
       do j=1  for #;      p= @.j                /*obtain the  Jth  prime.              */
       _= sumDigs(p);      if \!._  then iterate /*is sum of J's digs a prime? No, skip.*/       /* ◄■■■■■■■■ a filter. */
       found= found + 1                          /*bump the count of additive primes.   */
       if cols<0                    then iterate /*Build the list  (to be shown later)? */
       c= commas(p)                              /*maybe add commas to the number.      */
       $= $  right(c, max(w, length(c) ) )       /*add additive prime──►list, allow big#*/
       if found//cols\==0           then iterate /*have we populated a line of output?  */
       say center(idx, 7)'│'  substr($, 2);  $=  /*display what we have so far  (cols). */
       idx= idx + cols                           /*bump the  index  count for the output*/
       end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
if cols>0  then say '───────┴'center(""   ,  1 + cols*(w+1), '─')
say
say 'found '      commas(found)      title
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg ?; do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
sumDigs: parse arg x 1 s 2;  do k=2  for length(x)-1; s= s + substr(x,k,1); end;  return s
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: parse arg n;           @.1= 2;  @.2= 3;  @.3= 5;  @.4= 7;  @.5= 11;  @.6= 13
                    !.= 0;   !.2= 1;  !.3= 1;  !.5= 1;  !.7= 1;  !.11= 1;  !.13= 1
                           #= 6;  sq.#= @.# ** 2 /*the number of primes;  prime squared.*/
        do j=@.#+2  by 2  for max(0, n%2-@.#%2-1)       /*find odd primes from here on. */
        parse var  j   ''  -1  _                 /*obtain the last digit of the  J  var.*/
        if     _==5  then iterate;  if j// 3==0  then iterate  /*J ÷ by 5?   J ÷ by  3? */
        if j// 7==0  then iterate;  if j//11==0  then iterate  /*" "  " 7?   " "  " 11? */
                                                 /* [↓]  divide by the primes.   ___    */
              do k=6  while sq.k<=j              /*divide  J  by other primes ≤ √ J     */
              if j//@.k==0  then iterate j       /*÷ by prev. prime?  ¬prime     ___    */
              end   /*k*/                        /* [↑]   only divide up to     √ J     */
        #= # + 1;    @.#= j;  sq.#= j*j;  !.j= 1 /*bump prime count; assign prime & flag*/
        end   /*j*/;                      return
