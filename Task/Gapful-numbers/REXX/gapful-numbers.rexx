/*REXX program computes and displays a series of gapful numbers starting at some number.*/
numeric digits 20                                /*ensure enough decimal digits gapfuls.*/
parse arg gapfuls                                /*obtain optional arguments from the CL*/
if gapfuls=''  then gapfuls= 30 25@7123 15@1000000 10@1000000000      /*assume defaults.*/

        do until gapfuls='';      parse var gapfuls stuff gapfuls;       call gapful stuff
        end   /*until*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gapful: procedure; parse arg n "@" sp;  if sp==''  then sp= 100 /*get args; use default.*/
        say center(' 'n      " gapful numbers starting at: "     sp' ', 125, "═")
        $=;                   #= 0                              /*initialize the $ list.*/
               do j=sp  until #==n                              /*SP:  starting point.  */
               parse var   j   a  2  ''  -1  b                  /*get 1st and last digit*/
               if j // (a||b) \== 0  then iterate               /*perform  ÷  into  J.  */
               #= # + 1;             $= $ j                     /*bump #;  append ──► $ */
               end   /*j*/
        say strip($);     say;     return
