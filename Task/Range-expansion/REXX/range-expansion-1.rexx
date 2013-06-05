/*REXX program expands an ordered list of integers into an expanded list*/
old='-6,-3--1,   3-5,  7-11,14,15,       17-20';     a=translate(old,,',')
new=                                   /*change , ──► blanks  [↑]       */
     do until a=='';  parse var a X a  /*obtain the next integer|range. */
     p=pos('-',X,2)                    /*find location of a dash (maybe)*/
     if p==0 then  new=new X           /*append  X to the new list.     */
             else  do j=left(X,p-1) to substr(X,p+1)   /*Range? Build it*/
                   new=new j           /*append single integer at a time*/
                   end   /*j*/
     end   /*until*/

new=translate( strip(new),  ','  ," ") /*remove first blank, add commas.*/
say 'old list =' old                   /*show old list of numbers/ranges*/
say 'new list =' new                   /*show the  new  list of numbers.*/
                                       /*stick a fork in it, we're done.*/
