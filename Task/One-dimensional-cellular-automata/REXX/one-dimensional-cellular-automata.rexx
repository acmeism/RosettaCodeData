/*REXX program displays  N  generations of  one-dimensional cellular automata.*/
parse arg $ gens .;  if $=='' | $==','  then $=001110110101010  /*use default?*/
                     if gens==''        then gens=40            /* "     "    */
                     L=length($)-1                              /*adjusted len*/
  do #=0  for gens                                              /*process gens*/
  say  " generation"    right(#,length(gens))     ' '     translate($,"#·",10)
  @=0                                                           /*+ generation*/
         do j=2  for L;                    x=substr($,j-1,3)    /*obtain cell.*/
         if x==011 | x==101 | x==110  then @=overlay(1,@,j)     /*cell lives. */
                                      else @=overlay(0,@,j)     /*cell death. */
         end   /*j*/
  if $==@  then do;  say right('repeats',40);  leave;  end      /*it repeats? */
  $=@                                  /*now use the next generation of cells.*/
  end       /*#*/
                                       /*stick a fork in it,  we're all done. */
