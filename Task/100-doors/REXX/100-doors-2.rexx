/*REXX pgm solves the  100 doors  puzzle,  doing it the easy way by calculating squares.*/
parse arg doors .                                /*obtain the optional argument from CL.*/
if doors=='' | doors==","  then doors=100        /*not specified?  Then assume 100 doors*/
say 'After '          doors          " passes, the following doors are open:"
say
          do #=1  while  #**2 <= doors           /*process easy pass─through  (squares).*/
          say right(#**2, 20)                    /*add some indentation for the output. */
          end   /*#*/                            /*stick a fork in it,  we're all done. */
