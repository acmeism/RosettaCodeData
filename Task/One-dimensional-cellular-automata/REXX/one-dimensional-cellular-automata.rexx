/*REXX pgm displays generations of  one-dimensional  cellular automata. */
arg $ limit .;      if $=='' | $==','  then $=001110110101010  /*default*/
                    if limit==''       then limit=40           /*default*/

   do gen=0  to limit
   say ' generation'  right(gen,length(limit)) ' ' translate($,'#·',10)
   @='·'                                                   /*next gener.*/
       do j=2  to length($);        x=substr($,j-1,3)      /*get a cell.*/
       if x==011 | x==101 | x==110  then @=overlay(1,@,j)  /*cell lives.*/
                                    else @=overlay(0,@,j)  /*cell  dies.*/
       end   /*j*/
   if $==@  then do; say right('repeats',40); leave; end   /*it repeats?*/
   $=@                                 /*now use the next gen of cells. */
   end      /*gen*/
                                       /*stick a fork in it, we're done.*/
