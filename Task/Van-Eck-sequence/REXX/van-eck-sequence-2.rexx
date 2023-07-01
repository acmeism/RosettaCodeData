/*REXX pgm generates/displays the   'start ──► end'    elements of the Van Eck sequence.*/
parse arg LO HI sta .                            /*obtain optional arguments from the CL*/
if  LO=='' |  LO==","  then  LO=  1              /*Not specified?  Then use the default.*/
if  HI=='' |  HI==","  then  HI= 10              /* "      "         "   "   "     "    */
if sta=='' | sta==","  then sta=  0              /* "      "         "   "   "     "    */
$.0= sta;                    x= sta;      @.=.   /*$.: the  Van Eck  sequence as a list.*/
     do #=1 for HI-1                             /*X:  is the last term being examined. */
     if @.x==.  then do;   @.x= #;        $.#= 0;             x= 0;   end    /*new term.*/
                else do;     z= # - @.x;  $.#= z;   @.x= #;   x= z;   end    /*old term.*/
     end   /*#*/                                 /*Z:  the new term being added to list.*/
          LOw= LO - 1;     out= $.LOw            /*initialize the output value.         */
     do j=LO  to HI-1;     out= out $.j          /*build a list for the output display. */
     end   /*j*/                                 /*stick a fork in it,  we're all done. */
say 'terms '     LO     " through "     HI    ' of the Van Eck sequence are: '     out
