/*REXX program uses a command line interface to invoke Windows SAM for speech synthesis.*/
parse arg t                                      /*get the (optional) text from the C.L.*/
if t=''  then exit                               /*Nothing to say?    Then exit program.*/
dquote= '"'
rate= 1                                          /*talk:   -10 (slow)   to   10 (fast). */
                                                 /* [↓]  where the rubber meets the road*/
'NIRCMD'  "speak text"  dquote  t  dquote   rate /*NIRCMD  invokes Microsoft's Sam voice*/
                                                 /*stick a fork in it,  we're all done. */
