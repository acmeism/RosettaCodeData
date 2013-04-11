/*REXX program to test for a     Y   or   N     key when pressed.       */
prompt='Press  Y  or  N  for some reason.'       /*the  PROMPT  message.*/

  do until pos(ans,'NY')\==0   /*keep prompting until user answers Y | N*/
  say;   say prompt            /*show blank line, then show the prompt. */
  ans=inkey('wait'); upper ans /*get the answer(s), also, uppercase it. */
  end   /*until*/
                               /*stick a fork in it,  we're all done.   */
