/*REXX program to solve the 100 door puzzle, the easy-way version 2.*/
parse arg doors .            /*get the first argument (# of doors.) */
if doors=='' then doors=1000 /*not specified? Then assume 1000 doors*/
                                    /*   0 = closed.  */
                                    /*   1 = open.    */
door.=0                      /*assume all that all doors are closed.*/
say
say 'For the' doors "doors problem, the open doors are:"
say
      do j=1 for doors while j**2<=doors      /*limit pass-throughs.*/
      say right(j**2,20)
      end   /*j*/
