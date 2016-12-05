/*REXX program illustrates how to display embedded documentation (help) within REXX code*/
parse arg doc                                    /*obtain (all) the arguments from C.L. */
if doc='?'  then call help                       /*show documentation if arg=a single ? */
/*■■■■■■■■■regular■■■■■■■■■■■■■■■■■■■■■■■■■*/
/*■■■■■■■■■■■■■■■■■mainline■■■■■■■■■■■■■■■■*/
/*■■■■■■■■■■■■■■■■■■■■■■■■■■code■■■■■■■■■■■*/
/*■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■here.■■■■■*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
help: ?=0;    do j=1  for sourceline();  _=sourceline(j)         /*get a line of source.*/
              if _='<help>'   then do;  ?=1;  iterate;  end      /*search for  <help>   */
              if _='</help>'  then leave                         /*   "    "   </help>  */
              if ?            then say _
              end   /*j*/
      exit                                       /*stick a fork in it,  we're all done. */
/*══════════════════════════════════start of the in═line documentation AFTER the  <help>
<help>
       To use the  YYYY  program, enter one of:

             YYYY  numberOfItems
             YYYY                            (no arguments uses the default)
             YYYY  ?                         (to see this documentation)


       ─── where:  numberOfItems             is the number of items to be used.

           If no  "numberOfItems"  are entered, the default of  100  is used.
</help>
════════════════════════════════════end of the in═line documentation BEFORE the </help> */
