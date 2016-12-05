/*REXX program has a list of ten functions, each returns its invocation (index) squared.*/

     do j=1  for 9;    ?=random(0, 9)            /*invoke  random  functions nine times.*/
     interpret 'CALL .'?                         /*invoke a randomly selected function. */
     end   /*j*/                                 /* [↑]  the called function has no args*/

say 'The tenth invocation of  .0  ───► '   .0()
exit                                             /*stick a fork in it,  we're all done. */
/*───────────────────────────[Below is the closest thing to anonymous functions in REXX]*/
.0: return .();    .1: return .();    .2: return .();    .3: return .();    .4: return .()
.5: return .();    .6: return .();    .7: return .();    .8: return .();    .9: return .()
/*──────────────────────────────────────────────────────────────────────────────────────*/
.:   if symbol('@')=="LIT"  then @=0  /* ◄───handle very 1st invoke*/;  @=@+1;  return @*@
