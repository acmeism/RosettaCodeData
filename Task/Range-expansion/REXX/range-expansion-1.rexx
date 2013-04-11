/*REXX program expands an ordered list of integers into an expanded list*/
new=                                   /*new list of numbers (so far).  */
old='-6,-3--1,   3-5,  7-11,14,15,       17-20'  /*orig integers/ranges,*/
                                       /*blanks were added for comparing*/
a=translate(old,,',')                  /*translate commas (,) to blanks.*/

  do  until a=='';   parse var a X a   /*obtain the next integer|range. */
  _=pos('-',X,2)                       /*find location of a dash (maybe)*/
  if _\==0 then do k=left(X,_-1) to substr(X,_+1)  /*Dash? Process range*/
                new=new k              /*append single integer at a time*/
                end   /*k*/
           else new=new X              /*append  X to the new list.     */
  end   /*until*/

new=translate( strip(new),  ','  ," ") /*remove first blank, add commas.*/
say 'old list =' old                   /*show old list of numbers/ranges*/
say 'new list =' new                   /*show the  new  list of numbers.*/
                                       /*stick a fork in it, we're done.*/
