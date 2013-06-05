/* REXX **************************************************************
* 15.11.2012 Walter Pachl - my own solution
* 16.11.2012 Walter Pachl generalized n prisoners + w killing distance
*                         and s=number of survivors
* 09.05.2013 Walter Pachl accept arguments n w s and fix output
*                         thanks for the review/test
* I see no need for specifying a start count (actually a start number)
* This program should work on EVERY REXX.
* Pls report if this is not the case and let us know what's a problem.
**********************************************************************/
Parse Arg n w s .
If n='?' Then Do
  Say 'Invoke the program with the following arguments:'
  Say 'n number of prisoners            (default 41)'
  Say 'w killing count                  (default  3)'
  Say 's number of prisoners to survive (default  1)'
  Exit
  End
If n='' Then n=41                      /* number of alive prisoners  */
If w='' Then w=3                       /* killing count              */
If s='' Then s=1                       /* nuber of survivors         */
dead.=0                                /* nobody's dead yet          */
nn=n                                   /* wrap around boundary       */
p=-1                                   /* start here                 */
killed=''                              /* output of killings         */
Do until n=s                           /* until one alive prisoner   */
  found=0                              /* start looking              */
  Do Until found=w                     /* until we have the third    */
    p=p+1                              /* next position              */
    If p=nn Then p=0                   /* wrap around                */
    If dead.p=0 Then                   /* a prisoner who is alive    */
      found=found+1                    /* increment found count      */
    End
  dead.p=1
  /*
  Say 'killing' p 'now'
  */
  n=n-1                                /* shoot the one on this pos. */
  killed=killed p                      /* add to output              */
  End                                  /* End of main loop           */
Say 'killed:'killed                    /* output killing sequence    */
s=''
Do i=0 To nn-1                            /* look for the surviving p's */
  If dead.i=0 Then s=s i               /* found one                  */
  End
Say 'Survivor(s):'s                    /* show                       */
