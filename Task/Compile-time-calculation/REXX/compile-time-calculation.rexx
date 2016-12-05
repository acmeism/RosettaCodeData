/*REXX program computes 10! (ten factorial) during REXX's equivalent of "compile─time". */

say '10! ='    !(10)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
!: procedure;  !=1;            do j=2  to arg(1);    !=!*j;    end  /*j*/;        return !
