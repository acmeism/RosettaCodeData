/*REXX program prompts for two integers,  compares 'em,  tells results. */
numeric digits 1000                    /*for the users that go ka-razy. */
a=getInt('─────── Please enter your first integer:')  /*get 1st integer.*/
b=getInt('─────── Please enter your second integer:') /*get 2nd integer.*/

      if a<b  then say  a  ' is less than '     b
      if a=b  then say  a  ' is equal to '      b
      if a>b  then say  a  ' is greater than '  b
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GETINT subroutine───────────────────*/
getInt: procedure                      /*prompt the CBLF, get an integer*/
                                       /*¬geeks: Carbon-Based Life Form.*/
  do forever                           /*keep prompting until success.  */
  say;   say arg(1)                    /*display the prompt message.    */
  parse pull x                         /*get X, and keep its case intact*/
       select
       when x=''             then call serr 'Nothing was entered.'
       when words(x)>1       then call serr 'Too many arguments entered.'
       when \datatype(x,'N') then call serr "Argument isn't numeric:" x
       when \datatype(x,'W') then call serr "Argument isn't an integer:" x
       otherwise             return x  /*Eureka!  Return   X to invoker.*/
       end   /*select*/
  end        /*forever*/
/*──────────────────────────────────SERR subroutine─────────────────────*/
serr:  say '***error!*** ' arg(1);    say "Please try again.";    return
