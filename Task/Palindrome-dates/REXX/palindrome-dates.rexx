/*REXX program finds & displays the next  N  palindromic dates starting after 2020─02─02*/
/*                                                                      ─────           */
parse arg n from .                               /*obtain optional argumets from the CL*/
if    n=='' |    n==","  then    n= 15           /*Not specified?  Then use the default.*/
if from=='' | from==","  then from= '2020-02-02' /* "      "         "   "   "     "    */
#= 0                                             /*the count of palindromic dates so far*/
     do j=date('Base', from, "ISO")+1 until #==n /*find palindromic dates 'til  N  found*/
     aDate= date('ISO', j, "Base")               /*convert a "base" date to ISO format. */
     $= space( translate(aDate, , '-'),  0)      /*elide the dashes  (-)  in this date. */
     if $\==reverse($)  then iterate             /*Not palindromic?  Then skip this date*/
     say 'a palindromic date: '        aDate     /*display a palindromic date ──► term. */
     #= # + 1                                    /*bump the counter of palindromic dates*/
     end   /*j*/                                 /*stick a fork in it,  we're all done. */
