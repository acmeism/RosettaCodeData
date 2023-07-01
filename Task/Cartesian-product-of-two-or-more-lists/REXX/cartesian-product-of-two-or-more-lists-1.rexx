/*REXX program  calculates  the   Cartesian product   of two  arbitrary-sized  lists.   */
@.=                                              /*assign the default value to  @. array*/
parse arg @.1                                    /*obtain the optional value of  @.1    */
if @.1=''  then do;  @.1= "{1,2} {3,4}"          /*Not specified?  Then use the defaults*/
                     @.2= "{3,4} {1,2}"          /* "      "         "   "   "      "   */
                     @.3= "{1,2} {}"             /* "      "         "   "   "      "   */
                     @.4= "{}    {3,4}"          /* "      "         "   "   "      "   */
                     @.5= "{1,2} {3,4,5}"        /* "      "         "   "   "      "   */
                end
                                                 /* [↓]  process each of the  @.n values*/
  do n=1  while @.n \= ''                        /*keep processing while there's a value*/
  z= translate( space( @.n, 0),  ,  ',')         /*translate the  commas  to blanks.    */
     do #=1  until z==''                         /*process each elements in first list. */
     parse var  z   '{'  x.#  '}'   z            /*parse the list  (contains elements). */
     end   /*#*/
  $=
     do       i=1   for #-1                      /*process the subsequent lists.        */
       do     a=1   for words(x.i)               /*obtain the elements of the first list*/
         do   j=i+1 for #-1                      /*   "    "  subsequent lists.         */
           do b=1   for words(x.j)               /*   "    " elements of subsequent list*/
           $=$',('word(x.i, a)","word(x.j, b)')' /*append partial Cartesian product ──►$*/
           end   /*b*/
         end     /*j*/
       end       /*a*/
     end         /*i*/
  say 'Cartesian product of '       space(@.n)       " is ───► {"substr($, 2)'}'
  end            /*n*/                           /*stick a fork in it,  we're all done. */
