/*REXX program tests for a    Y  or  N    key when entered from keyboard after a prompt.*/
prompt = 'Please enter   Y  or  N   for verification:'   /*this is the  PROMPT  message.*/

  do  until  pos(ans, 'NYny') \== 0              /*keep prompting until answer= Y N y n */
  say;       say prompt                          /*display blank line;  display prompt. */
  ans=inKey('wait')                              /*get the answer(s) from the terminal. */
  end   /*until*/
                                                 /*stick a fork in it,  we're all done. */
