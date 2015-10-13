/*REXX pgm creates a new empty file and directory; in curr dir and root.*/
fn='input.txt'
dn='docs'
@.1='current directory';   @.2='root directory'    /*msgs for each pass.*/
parse upper version v;  regina=pos('REGINA',v)\==0 /*Regina being used? */

  do j=1 for 2;    say                 /*perform these statements twice.*/
  if stream(fn,'C',"QUERY EXISTS")==''  then say 'file ' fn " doesn't exist in the" @.j
                                        else say 'file ' fn    " does exist in the" @.j
  if dosisdir(dn)  then say 'directory ' dn    " does exist in the" @.j
                   else say 'directory ' dn " doesn't exist in the" @.j
  if regina  then call    chdir '\'    /*use Regina's version of  CHDIR.*/
             else call doschdir '\'    /*PC/REXX & Personal REXX version*/
  end   /*j*/                          /*now, go and perform them again.*/
                                       /*stick a fork in it, we're done.*/
