/*REXX program expands an  ordered list  of  integers  into  an expanded list.          */
old= '-6,-3--1,   3-5,  7-11,       14,15,17-20';       a=translate(old,,',')
new=                                             /*translate [↑]  commas (,) ───► blanks*/
      do until a=='';   parse var a X a          /*obtain the next integer ──or── range.*/
      p=pos('-', X, 2)                           /*find the location of a dash (maybe). */
      if p==0 then  new=new   X                  /*append integer   X   to the new list.*/
              else  do j=left(X,p-1)  to substr(X,p+1);     new=new j
                    end   /*j*/                  /*append a single [↑] integer at a time*/
      end                 /*until*/
                                                 /*stick a fork in it,  we're all done. */
new=translate( strip(new),  ',',  " ")           /*remove the first blank,  add commas. */
say 'old list: '   old                           /*show the  old list of numbers/ranges.*/
say 'new list: '   new                           /*  "   "   new   "   " numbers.       */
