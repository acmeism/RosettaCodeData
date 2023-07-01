/*REXX program creates a  range extraction  from a  list of numbers  (can be negative.) */
old=0 1 2 4 6 7 8 11 12 14 15 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 32 33 35 36 37 38 39
#= words(old);        j= 0                       /*number of integers in the number list*/
new=                                             /*the new list, possibly with ranges.  */
     do  while j<#;   j= j + 1;  z= word(old, j) /*get the Jth number in the number list*/
     inc= 1;                   new= new','z      /*append   "    "    to  "   new     " */
              do k=j+1  to #;    y= word(old, k) /*get the Kth number in the number list*/
              if y\==z+inc  then leave           /*is this number not > previous by inc?*/
              inc= inc + 1;      g= y            /*increase the range, assign  G (good).*/
              end   /*k*/
     if k-1=j   |   g=z+1   then iterate         /*Is the range=0│1?  Then keep truckin'*/
     new= new'-'g;               j= k - 1        /*indicate a range of numbers; change J*/
     end            /*while*/
                                                 /*stick a fork in it,  we're all done. */
new= substr(new, 2)                              /*elide the leading comma in the list. */
say 'old:'   old;           say 'new:'  new      /*show the old and new range of numbers*/
