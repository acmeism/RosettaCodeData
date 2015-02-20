/*REXX pgm has a list of 10 functions, each returns its invocation(idx)²*/

     do j=1  for 9                    /*invoke random functions 9 times.*/
     interpret 'CALL .'random(0,9)    /*invoke a randomly selected func.*/
     end   /*j*/                      /* [↑] the random func has no args*/

say 'The tenth invocation of  .0  ───► ' .0()
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────list of 10 functions─────────────────*/
/*[Below is the closest thing to anonymous functions in the REXX lang.] */
 .0:return .(); .1:return .(); .2:return .(); .3:return .(); .4:return .()
 .5:return .(); .6:return .(); .7:return .(); .8:return .(); .9:return .()
/*─────────────────────────────────. function───────────────────────────*/
.: if symbol('@')=='LIT' then @=0 /*handle 1st invoke*/; @=@+1; return @*@
