/*REXX program  computes and displays a  specified number of  happy  numbers. */
parse arg limit .                      /*get optional arguments from the C.L. */
if limit=='' | limit==',' then limit=8 /*Not specified?  Then use the default.*/
haps=0                                 /*count of the happy numbers  (so far).*/

  do n=1  while haps<limit;    @.=0    /*search the integers starting at unity*/
  q=n;   do  until q==1                /*determine if   Q   is a happy number.*/
         s=0                           /*prepare to add squares of digits.    */
                 do j=1  for length(q) /*sum the squares of the decimal digits*/
                 s=s+substr(q,j,1)**2  /*add the square  of  a  decimal digit.*/
                 end   /*j*/

         if @.s  then iterate n        /*if already summed,   Q   is unhappy. */
         @.s=1;  q=s                   /*mark the sum as found;   try  Q  sum.*/
         end   /*until*/
  say n                                /*display the number    (N  is happy). */
  haps=haps+1                          /*bump the  count  of  happy numbers.  */
  end          /*n*/
                                       /*stick a fork in it,  we're all done. */
