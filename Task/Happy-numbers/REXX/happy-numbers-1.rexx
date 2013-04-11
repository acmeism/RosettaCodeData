/*REXX program displays  eight  (or a specified limit)  happy  numbers. */
parse arg limit .                      /*get optional argument  LIMIT.  */
if limit=='' | limit==',' then limit=8 /*Not specified?  Set LIMIT to 8.*/
haps=0                                 /*count of happy numbers so far. */

  do n=1  while haps<limit;  q=n; a.=0 /*search integers starting at  1.*/
         do  until q==1                /*see if   Q   is a happy number.*/
         s=0                           /*prepare to add squares of digs.*/
                 do j=1  for length(q) /*sum the squares of the digits. */
                 s=s+substr(q,j,1)**2  /*add the square  of  a  digit.  */
                 end   /*j*/

         if a.s  then iterate n        /*if already summed, Q is unhappy*/
         a.s=1;  q=s                   /*mark sum as found, try  Q  sum.*/
         end   /*until*/
  say n                                /*display the number (N is happy)*/
  haps=haps+1                          /*bump the count of happy numbers*/
  end          /*n*/
                                       /*stick a fork in it, we're done.*/
