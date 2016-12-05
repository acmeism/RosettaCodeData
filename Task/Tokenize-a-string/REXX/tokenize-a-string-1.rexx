/*REXX program separates a string of comma-delimited words, and echoes. */
sss = 'Hello,How,Are,You,Today'        /*words seperated by commas (,). */
say 'input string =' sss               /*display the original string.   */
new=sss                                /*make a copy of the string.     */
                                       /* [↓]  string NEW is destroyed. */
  do items=1  until  new==''           /*keep going until  NEW is empty.*/
  parse  var  new a.items  ','  new    /*parse words delinated by comma.*/
  end   /*items*/                      /* [↑]  the array is named   A.  */

say;   say 'Words in the string:'      /*display a header for the list. */

     do j=1  for items                 /*now, display all the words.    */
     say a.j || left('.', j\==items)   /*append period to word,  maybe. */
     end   /*j*/                       /* [↑]  don't append "." if last.*/

say 'End-of-list.'                     /*display a trailer for the list.*/
                                       /*stick a fork in it, we're done.*/
