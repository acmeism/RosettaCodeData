/*REXX program to prompt user for template substitutions within a story.*/
@.=;   !.=0;   #=0;   @=               /*assign some defaults.          */
parse arg iFID .                       /*allow use to specify input file*/
if iFID==''  then iFID="MAD_LIBS.TXT"  /*Not specified? Then use default*/

   do recs=1  while lines(iFID)\==0    /*read the input file 'til done. */
   @.recs=linein(iFID);  @=@ @.recs    /*read a record, append it to  @ */
   if @.recs=''  then leave            /*Read a blank line?  We're done.*/
   end  /*recs*/

recs=recs-1                            /*adjust for E─O─F or blank line.*/

     do forever                        /*look for templates in the text.*/
     parse var  @   '<'   ?   '>'   @  /*scan for  <ααα>  stuff in text.*/
     if ?=''   then leave              /*if no   ααα,  then we're done. */
     if !.?    then iterate            /*already asked?   Keep scanning.*/
     !.?=1                             /*mark this   ααα   as  "found". */
            do forever                 /*prompt user for a replacement. */
            say '─────────── please enter a word or phrase to replace: ' ?
            parse pull ans;    if ans\=''  then leave
            end   /*forever*/
     #=#+1                             /*bump the template counter.     */
     old.# = '<'?">";    new.# = ans   /*assign "old" name & "new" name.*/
     end   /*forever*/

say;     say copies('═',79)            /*display a blank and a fence.   */

     do m=1  for recs                  /*display the text, line for line*/
                       do n=1  for #   /*perform substitutions in text. */
                       @.m = changestr(old.n, @.m, new.n)
                       end   /*n*/
     say @.m                           /*display (new) substituted text.*/
     end   /*m*/

say copies('═',79)                     /*display a final (output) fence.*/
                                       /*stick a fork in it, we're done.*/
