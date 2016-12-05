/*REXX program tests for a    Y  or  N    key when entered from keyboard after a prompt.*/
prompt = 'Please enter   Y  or  N   for verification:'   /*this is the  PROMPT  message.*/

  do  until  pos(ans, 'NY')\==0                   /*keep prompting 'til user answers Y│N */
  say;       say prompt                         /*display blank line;  display prompt. */
  ans=inKey('wait');  upper ans                  /*get the answer(s);  and uppercase it.*/
  end   /*until*/
                                                 /*stick a fork in it,  we're all done. */
