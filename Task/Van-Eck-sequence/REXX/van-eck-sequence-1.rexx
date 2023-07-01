/*REXX pgm generates/displays the   'start ──► end'    elements of the Van Eck sequence.*/
parse arg LO HI $ .                              /*obtain optional arguments from the CL*/
if LO=='' | LO==","  then LO=   1                /*Not specified?  Then use the default.*/
if HI=='' | HI==","  then HI=  10                /* "      "         "   "   "     "    */
if  $=='' |  $==","  then  $=   0                /* "      "         "   "   "     "    */
$$=;               z= $                          /*$$: old seq:  $: initial value of seq*/
     do HI-1;      z= wordpos( reverse(z), reverse($$) );          $$= $;          $= $ z
     end   /*HI-1*/                              /*REVERSE allows backwards search in $.*/
                                                 /*stick a fork in it,  we're all done. */
say 'terms '  LO  " through "  HI  ' of the Van Eck sequence are: '  subword($,LO,HI-LO+1)
