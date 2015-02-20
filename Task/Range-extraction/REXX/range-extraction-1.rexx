/*REXX program  creates  a  range extraction  from a  list of integers. */
old=0 1 2 4 6 7 8 11 12 14 15 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 32 33 35 36 37 38 39
w=words(old)                           /*number of integers in the list.*/
new=                                   /*new list, possibly with ranges.*/
     do j=1  to  w;      x=word(old,j) /*get the Jth number in the list.*/
     new=new','  x                     /*append  Jth number to new list.*/
     inc=1                             /*start with an increment of one.*/
         do k=j+1  to w; y=word(old,k) /*get the Kth number in the list.*/
         if y\=x+inc     then leave    /*is this number ¬> prev by inc? */
         inc=inc+1;      g=y           /*increase range, assign g (good)*/
         end   /*k*/
     if k-1=j  |  g=x+1  then iterate  /*range= 0|1?  Then keep truckin'*/
     new=new'-'g                       /*indicate a  range  of numbers. */
     j=k-1                             /*changing the  J  DO loop index.*/
     end       /*j*/

new=space(substr(new, 2), 0)           /*elide leading comma, all blanks*/
say 'old:'  old                        /*show the old range of numbers. */
say 'new:'  new                        /*  "   "  new  list  "    "     */
                                       /*stick a fork in it, we're done.*/
