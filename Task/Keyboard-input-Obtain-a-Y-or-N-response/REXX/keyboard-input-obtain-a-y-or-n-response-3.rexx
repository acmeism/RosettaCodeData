/*REXX program to test for a     Y   or   N     key when pressed.       */
prompt = 'Please press   Y  or  N   for verification:'     /*PROMPT msg.*/

  do  until  pos(ans,'NY')\==0 /*keep prompting until user answers Y | N*/
  say;   say prompt            /*show blank line, then show the prompt. */
  ans=inkey('wait'); upper ans /*get the answer(s), also, uppercase it. */
  end   /*until*/
                               /*stick a fork in it,  we're all done.   */
