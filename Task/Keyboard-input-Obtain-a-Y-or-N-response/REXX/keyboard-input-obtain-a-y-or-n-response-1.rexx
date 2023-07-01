/*REXX program tests for a    Y  or  N    key when entered from keyboard after a prompt.*/

  do queued();   pull;   end                     /*flush the stack if anything is queued*/

prompt = 'Please enter   Y  or  N   for verification:'   /*this is the  PROMPT  message.*/

  do  until  pos(ans,'NY')\==0 & length(ans)==1  /*keep looking for a  Y  or  N  answer.*/
  say;       say prompt                          /*display blank line;  display prompt. */
  pull ans                                       /*get the answer(s)  and  uppercase it.*/
  ans=space(ans, 0)                              /*elide all blanks.                    */
  end   /*until*/
                                                 /*stick a fork in it,  we're all done. */
