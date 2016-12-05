/*REXX program prompts the user for a template substitutions within a story  (MAD LIBS).*/
parse arg iFID .                                 /*allow user to specify the input file.*/
if iFID=='' | iFID=="," then iFID="MAD_LIBS.TXT" /*Not specified?  Then use the default.*/
@.=                                              /*assign defaults to some variables.   */
$=;          do recs=1  while  lines(iFID)\==0   /*read the input file until it's done. */
             @.recs=linein(iFID);  $=$  @.recs   /*read a record;  and append it to  @  */
             if @.recs=''  then leave            /*Read a blank line?   Then we're done.*/
             end  /*recs*/
recs=recs-1                                      /*adjust for a E─O─F  or  a blank line.*/
pm= 'please enter a word or phrase to replace: ' /*this is part of the  Prompt Message. */
!.=0                                             /*placeholder for phrases in  MAD LIBS.*/
#=0;    do  forever                              /*look for templates within the text.  */
        parse var  $   '<'   ?   ">"   $         /*scan for   <ααα>   stuff in the text.*/
        if ?=''   then leave                     /*No   ααα ?   Then we're all finished.*/
        if !.?    then iterate                   /*Already asked?   Then keep scanning. */
        !.?=1                                    /*mark this   ααα   as being  "found". */
               do  until  ans\=''                /*prompt user for a replacement.       */
               say '───────────'   pm    ?       /*prompt the user with a prompt message*/
               parse pull ans                    /*PULL  obtains the text from console. */
               end   /*forever*/
        #=#+1                                    /*bump the template counter.           */
        old.# = '<'?">";           new.# = ans   /*assign the "old" name and "new" name.*/
        end   /*forever*/
say                                              /*display a blank line for a separator.*/
say;  say copies('═', 79)                        /*display a blank line  and  a fence.  */

        do m=1  for recs                         /*display the text,  line for line.    */
                do n=1  for #                    /*perform substitutions in the text.   */
                @.m=changestr(old.n, @.m, new.n) /*maybe replace text in  @.m  haystack.*/
                end   /*n*/
        say @.m                                  /*display the (new) substituted text.  */
        end   /*m*/

say copies('═', 79)                              /*display a  final (output) fence.     */
say                                              /*stick a fork in it,  we're all done. */
