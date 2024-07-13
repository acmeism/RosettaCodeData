/*REXX pgm generates/displays the 'start --? end' elements of the Van Eck sequence.*/
Parse Arg lo hi sta .                       /*obtain optional arguments from the CL*/
If  lo=='' |  lo==','  Then  lo=  1         /*Not specified?  Then use the default.*/
If  hi=='' |  hi==','  Then  hi= 10         /* "      "         "   "   "     "    */
If sta=='' | sta==','  Then sta=  0         /* "      "         "   "   "     "    */
d.0=sta                                     /*d.: the  Van Eck  sequence as a list.*/
x=sta
a.=.
out='0'
Do n=1 For hi-1                             /*X:  is the last term being examined. */
  If a.x==. Then Do                         /* new term.                           */
    a.x=n
    d.n=0
    x=0
    End
  Else Do                                   /* old term.                           */
    z=n-a.x
    d.n=z
    a.x=n
    x=z
    End
  out=out d.n
  End   /*n*/                               /*Z:  the new term being added To list.*/
low=lo-1
out=d.low                                   /* initialize the output list          */
Do j=lo To hi-1
  out=out d.j                               /*build a list For the output display. */
  End   /*j*/
Say 'terms ' lo ' through ' hi ' of the Van Eck sequence are: ' out
                                            /*stick a fork in it,  we're all done. */
