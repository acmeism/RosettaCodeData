/*REXX program to test for a     Y   or   N     key when pressed.       */
prompt = 'Please press   Y  or  N   for verification:'     /*PROMPT msg.*/

  do until pos(ans,'NYny')\==0 /*keep prompting until answer =  Y N y n */
  say;   say prompt            /*show blank line, then show the prompt. */
  ans=inkey('wait')            /*get the answer(s) from the terminal.   */
  end   /*until*/
                               /*stick a fork in it,  we're all done.   */
