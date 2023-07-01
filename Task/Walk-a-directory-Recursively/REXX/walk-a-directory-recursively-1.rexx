/*REXX program shows all files in a  directory tree  that match a given search criteria.*/
parse arg xdir;  if xdir=''  then xdir='\'       /*Any DIR specified?  Then use default.*/
@.=0                                             /*default result in case ADDRESS fails.*/
dirCmd= 'DIR /b /s'                              /*the DOS command to do heavy lifting. */
trace off                                        /*suppress REXX error message for fails*/
address system  dirCmd xdir  with output stem @. /*issue the DOS DIR command with option*/
if rc\==0  then do                               /*did the DOS DIR command get an error?*/
                say '***error!*** from DIR' xDIR /*error message that shows "que pasa". */
                say 'return code='  rc           /*show the  return code  from  DOS DIR.*/
                exit rc                          /*exit with    "     "     "    "   "  */
                end                              /* [↑]  bad ADDRESS cmd  (from DOS DIR)*/
#=@.rc                                           /*the number of  @.  entries generated.*/
if #==0  then #='   no   '                       /*use a better word choice for 0 (zero)*/
say center('directory '      xdir      " has "      #       ' matching entries.', 79, "─")

                do j=1  for #;       say @.j     /*show all the files that met criteria.*/
                end   /*j*/
exit @.0+rc                                      /*stick a fork in it,  we're all done. */
