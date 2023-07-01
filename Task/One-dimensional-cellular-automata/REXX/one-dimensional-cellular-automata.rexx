/*REXX program generates & displays N generations of one─dimensional cellular automata. */
parse arg $ gens .                               /*obtain optional arguments from the CL*/
if    $=='' |    $==","  then $=001110110101010  /*Not specified?  Then use the default.*/
if gens=='' | gens==","  then gens=40            /* "      "         "   "   "     "    */

   do #=0  for gens                              /* process the  one-dimensional  cells.*/
   say  " generation"    right(#,length(gens))       ' '       translate($, "#·", 10)
   @=0                                                                /* [↓] generation.*/
          do j=2  for length($) - 1;          x=substr($, j-1, 3)     /*obtain the cell.*/
          if x==011 | x==101 | x==110  then @=overlay(1, @, j)        /*the cell lives. */
                                       else @=overlay(0, @, j)        /* "   "    dies. */
          end   /*j*/

   if $==@  then do;  say right('repeats', 40);  leave;  end          /*does it repeat? */
   $=@                                           /*now use the next generation of cells.*/
   end       /*#*/                               /*stick a fork in it,  we're all done. */
