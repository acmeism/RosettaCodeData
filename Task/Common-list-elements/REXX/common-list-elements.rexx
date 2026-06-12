/*REXX program finds and displays the  common list elements  from a collection of sets. */
parse arg a                                      /*obtain optional arguments from the CL*/
if a='' | a=","  then a= '[2,5,1,3,8,9,4,6]  [3,5,6,2,9,8,4]  [1,3,7,6,9]'   /*defaults.*/
#= words(a)                                      /*the number of sets that are specified*/
            do j=1  for #                        /*process each set  in  a list of sets.*/
            @.j= translate( word(a, j), ,'],[')  /*extract   a   "  from "   "   "   "  */
            end   /*j*/
$=                                               /*the list of common elements (so far).*/
   do k=1  for #-1                               /*use the last set as the base compare.*/
      do c=1  for words(@.#);  x= word(@.#, c)   /*obtain an element from a set.        */
         do f=1  for #-1                         /*verify that the element is in the set*/
         if wordpos(x, @.f)==0  then iterate c   /*Is in the set?  No, then skip element*/
         end   /*f*/
      if wordpos(x, $)==0  then $= $ x           /*Not already in the set?  Add common. */
      end      /*c*/
   end         /*k*/
                                                 /*stick a fork in it,  we're all done. */
say 'the list of common elements in all sets: '       "["translate(space($), ',', " ")']'
