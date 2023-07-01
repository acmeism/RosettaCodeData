/*REXX program  executes a  system command  and displays the results  (from an array).  */
parse arg xxxCmd                                 /*obtain the (system) command from  CL.*/
trace off                                        /*suppress REXX error msgs for fails.  */
@.= 0                                            /*assign default in case ADDRESS fails.*/
address  system  xxxCmd  with  output  stem  @.  /*issue/execute the command and parms. */
if rc\==0  then  say  copies('─', 40)      ' return code '     rc     " from: "     xxxCmd
                                                 /* [↑]  display if an  error  occurred.*/
           do #=1  for @.0                       /*display the output from the command. */
           say strip(@.#, 'T')                   /*display one line at a time──►terminal*/
           end   /*#*/                           /* [↑]  displays all the output.       */
exit 0                                           /*stick a fork in it,  we're all done. */
