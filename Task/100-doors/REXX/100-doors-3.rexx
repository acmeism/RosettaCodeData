/*REXX program to solve the 100 door puzzle, the easy-way version.  */
parse arg doors .            /*get the first argument (# of doors.) */
if doors=='' then doors=100  /*not specified?  Then assume 100 doors*/
                                    /*   0 = closed.  */
                                    /*   1 = open.    */
door.=0                      /*assume all that all doors are closed.*/
say
say 'For the' doors "doors problem, the following doors are open:"
say
      do j=1 for doors       /*process an easy pass-through.        */
      p=j**2                 /*square the door number.              */
      if p>doors then leave  /*if too large, we're done.            */
      say right(p,20)
      end   /*j*/
