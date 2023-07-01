/*REXX pgm counts the number of twin prime pairs under a specified number N (or a list).*/
parse arg $ .                                    /*get optional number of primes to find*/
if $='' | $=","  then $= 10 100 1000 10000 100000 1000000 10000000  /*No $? Use default.*/
w= length( commas( word($, words($) ) ) )        /*get length of the last number in list*/
@found= ' twin prime pairs found under '         /*literal used in the showing of output*/

       do i=1  for words($);       x= word($, i) /*process each N─limit in the  $  list.*/
       say right( commas(genP(x)), 20)     @found     right(commas(x), max(length(x), w) )
       end   /*i*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _;  do ?=length(_)-3  to 1  by -3; _=insert(',', _, ?); end;   return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: parse arg y; @.1=2;  @.2=3;  @.3=5;  @.4=7;  @.5=11;  @.6=13; #= 6; tp= 2; sq.6= 169
      if y>10  then tp= tp+1
         do j=@.#+2  by 2  for max(0, y%2-@.#%2-1)      /*find odd primes from here on. */
         parse var  j   ''  -1  _                /*obtain the last digit of the  J  var.*/
         if    _==5  then iterate;  if j// 3==0  then iterate  /*J ÷ by 5?   J ÷ by  3? */
         if j//7==0  then iterate;  if j//11==0  then iterate  /*" "  " 7?   " "  " 11? */
                                                 /* [↓]  divide by the primes.   ___    */
               do k=6  to #  while  sq.k<=j      /*divide  J  by other primes ≤ √ J     */
               if j//@.k == 0  then iterate j    /*÷ by prev. prime?  ¬prime     ___    */
               end   /*k*/                       /* [↑]   only divide up to     √ J     */
         prev= @.#;  #= #+1;  sq.#= j*j;  @.#= j /*save prev. P; bump # primes; assign P*/
         if j-2==prev   then tp= tp + 1          /*This & previous prime twins? Bump TP.*/
         end         /*j*/;            return tp
