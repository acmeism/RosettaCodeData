/*REXX program uses a command line interface to invoke Windows SAM for speech synthesis.*/
parse arg t                                      /*get the (optional) text from the C.L.*/
#= words(t)
if #==0  then exit                               /*Nothing to say?    Then exit program.*/
dq= '"'                                          /*needed to enclose text in dbl quotes.*/
rate= 1                                          /*talk:   -10 (slow)   to   10 (fast). */
                                                 /* [↓]  where the rubber meets the road*/
   do j=1  for #
   x= word(t, j);          upper x               /*extract 1 word, capitalize it for HL.*/
   if j==1  then LHS=                            /*obtain text before the spoken word.  */
            else LHS= subword(t, 1, j-1)
   if j==#  then RHS=                            /*obtain text  after the spoken word.  */
            else RHS= subword(t, j+1)
   'CLS'                                         /*use this command to clear the screen.*/
   say 'speaking: '   space(LHS  x  RHS)         /*show text,  one word is capitalized. */
   oneWord= dq  x  dq                            /*surround a word in double quotes (").*/
   'NIRCMD'  "speak text"    oneWord     rate    /*NIRCMD  invokes Microsoft's Sam voice*/
   end   /*j*/                                   /*stick a fork in it,  we're all done. */
