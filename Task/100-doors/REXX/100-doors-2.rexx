/*REXX program to solve the 100 door puzzle, the hard-way version.  */
parse arg doors .            /*get the first argument (# of doors.) */
if doors=='' then doors=100  /*not specified?  Then assume 100 doors*/
                                    /*   0 = closed.  */
                                    /*   1 = open.    */
door.=0                      /*assume all that all doors are closed.*/

     do j=1 for doors        /*process a pass-through for all doors.*/
       do k=j by j to doors  /* ... every Jth door from this point. */
       door.k=\door.k        /*toggle the  "openness"  of the door. */
       end   /*k*/
     end     /*j*/
say
say 'After' doors "passes, the following doors are open:"
say
          do n=1 for doors
          if door.n then say right(n,20)
          end    /*n*/
