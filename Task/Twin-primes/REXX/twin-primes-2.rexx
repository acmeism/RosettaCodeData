/*REXX pgm counts the number of twin prime pairs under a specified number N (or a list).*/
parse arg $ .                                    /*get optional number of primes to find*/
if $='' | $=","  then $= 100 1000 10000 100000 1000000 10000000    /*No $?  Use default.*/
w= length( commas( word($, words($) ) ) )        /*get length of the last number in list*/
@found= ' twin prime pairs found under '         /*literal used in the showing of output*/

       do i=1  for words($);       x= word($, i) /*process each N─limit in the  $  list.*/
       say right( commas(genP(x)), 20)     @found     right(commas(x), max(length(x), w) )
       end   /*i*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _;  do ?=length(_)-3  to 1  by -3; _=insert(',', _, ?); end;   return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: arg y; _= 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101
      tp=8;          #= words(_); sq.103=103*103 /*#: number of prims; TP: # twin pairs.*/
        do aa=1  for #;  @.aa= word(_, aa)       /*assign some low primes for quick ÷'s.*/
        end   /*aa*/

        do j=@.#+2  by 2  while j<y              /*continue with the next prime past 101*/
        parse var  j  ''  -1  _                  /*obtain the last digit of the  J  var.*/
        if _    ==5       then iterate           /*is this integer a multiple of five?  */
        if j//3 ==0       then iterate           /* "   "     "    "     "     " three? */

           do a=4  for 23                        /*divide low primes starting with seven*/
           if j//@.a ==0  then iterate j         /*is integer a multiple of a low prime?*/
           end           /*a*/
                                                 /* [↓]  divide by the primes.   ___    */
                   do k=27  to #  while sq.k<= j /*divide  J  by other primes ≤ √ J     */
                   if j//@.k ==0  then iterate j /*÷ by prev. prime?  ¬prime     ___    */
                   end   /*k*/                   /* [↑]   only divide up to     √ J     */
        prev= @.#;  #= #+1;  sq.#= j*j;   @.#= j /*save prev. P; bump # primes; assign P*/
        if j-2==prev  then tp= tp + 1            /*This & previous prime twins? Bump TP.*/
        end              /*j*/;        return tp
