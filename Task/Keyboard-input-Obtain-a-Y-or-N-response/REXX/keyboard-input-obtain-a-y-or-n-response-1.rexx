/*REXX program to test for a  Y  or  N  key when entered after a prompt.*/

  do queued();   pull;   end          /*flush stack if anything queued. */

prompt = 'Please enter  Y  or  N  for verification:'       /*PROMPT msg.*/
                                      /* [↓] keep prompting til answered*/
  do until pos(ans,'NY')\==0 & length(space(ans,0))==1     /*··· Y | N ?*/
  say;      say prompt                /*show blank line, show the prompt*/
  pull ans                            /*get the answer(s) & uppercase it*/
  end   /*until*/
                                      /*stick a fork in it,  we're done.*/
