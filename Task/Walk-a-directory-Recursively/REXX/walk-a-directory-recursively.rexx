/*REXX program shows files in a  single directory that match a criteria.*/
parse arg xdir;  if xdir='' then xdir='\'        /*Any DIR? Use default.*/
@.=0                                   /*default in case ADDRESS fails. */
trace off                              /*suppress REXX err msg for fails*/
address system 'DIR' xdir '/b' with output stem @.  /*issue the DIR cmd.*/
if rc\==0  then do                                  /*an error happened?*/
                say '***error!*** from DIR' xDIR    /*indicate que pasa.*/
                say 'return code='  rc              /*show the Ret Code.*/
                exit rc                             /*exit with the  RC.*/
                end                                 /* [↑]  bad address.*/
#=@.rc                                              /*number of entries.*/
if #==0  then #='   no   '                          /*use a word, ¬zero.*/
say center('directory ' xdir " has "    #     ' matching entries.',79,'─')

       do j=1  for #;  say @.j;  end   /*show files that met criteria.  */

exit @.0+rc                            /*stick a fork in it, we're done.*/
