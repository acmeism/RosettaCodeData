/*REXX program breaks up a  word  (or string)  into a  list of words  from a dictionary.*/
parse arg a '/' x;   a=space(a);     x=space(x)  /*get optional args; elide extra blanks*/
if a=='' | a==","  then a= 'abcd abbc abcbcd acdbc abcdd' /*Not specififed?  Use default*/
if x=='' | x==","  then x= 'a bc abc cd b'                /* "      "        "      "   */
na= words(a)                                     /*the number of words to be tested.    */
nx= words(x)                                     /* "     "    "   "    " the dictionary*/
say nx  ' dictionary words: '   x                /*display the words in the dictionary. */
aw= 0                                            /*maximum word width obtained (so far).*/
say                                              /*display a blank line to the terminal.*/
      do i=1  for na;           _= word(a, i)    /*obtain a word that will be tested.   */
      aw= max(aw, length(_) )                    /*find widest width word being tested. */
      end   /*i*/                                /* [↑]  AW  is used to align the output*/
@.= 0                                            /*initialize the dictionary to "null". */
xw= 0
      do i=1  for nx;           _= word(x, i)    /*obtain a word from the dictionary.   */
      xw= max(xw, length(_) );  @._= 1           /*find widest width dictionary word.   */
      end   /*i*/                                /* [↑]  define a dictionary word.      */
p= 0                                             /* [↓]  process a word in the  A  list.*/
      do j=1  for na;           yy= word(a, j)   /*YY:   test a word  from the  A  list.*/
        do t=(nx+1)**(xw+1)  by -1  to 1  until y=='';  y= yy    /*try word possibility.*/
        $=                                       /*nullify the (possible) result list.  */
           do try=t  while y\=''                 /*keep testing until  Y  is exhausted. */
           p= (try + p)  // xw    + 1            /*use a possible width for this attempt*/
           p= fw(y, p);  if p==0  then iterate t /*is this part of the word not found ? */
           $= $ ?                                /*It was found. Add partial to the list*/
           y= substr(y,  p + 1)                  /*now, use and test the rest of word.  */
           end   /*try*/
        end      /*t*/

      if t==0  then $= '(not possible)'          /*indicate that the word isn't possible*/
      say right(yy, aw)    '───►'    strip($)    /*display the result to the terminal.  */
      end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fw: parse arg z,L;  do k=L  by -1  for L; ?=left(z,k); if @.?  then leave; end;   return k
