/*REXX program reads a (bio-informational)  FASTA  file  and  displays the contents.    */
parse arg iFID .                                 /*iFID:  the input file to be read.    */
if iFID==''  then iFID='FASTA.IN'                /*Not specified?  Then use the default.*/
name=                                            /*the name of an output file (so far). */
$=                                               /*the value of the output file's stuff.*/
     do  while  lines(iFID)\==0                  /*process the  FASTA  file contents.   */
     x=strip( linein(iFID), 'T')                 /*read a line (a record) from the file,*/
                                                 /*───────── and strip trailing blanks. */
     if left(x, 1)=='>'  then do
                              if $\==''  then say name':'  $
                              name=substr(x,  2)
                              $=
                              end
                         else $=$ || x
     end   /*j*/                                 /* [↓]  show output of last file used. */
if $\==''  then say name':'  $                   /*stick a fork in it,  we're all done. */
