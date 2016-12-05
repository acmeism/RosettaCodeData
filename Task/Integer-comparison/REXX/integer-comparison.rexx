/*REXX program  prompts  for  two integers,   compares them,  and  displays the results.*/
numeric digits 1000                              /*for the users that really go ka─razy.*/
@=copies('─', 20)                                /*eyeball catcher for the user's eyen. */
a=getInt(@  'Please enter your 1st integer:')    /*obtain the 1st integer from the user.*/
b=getInt(@  'Please enter your 2nd integer:')    /*   "    "  2nd    "      "   "    "  */
say
      if a<b  then say  @   a    ' is less than '        b
      if a=b  then say  @   a    ' is equal to '         b
      if a>b  then say  @   a    ' is greater than '     b
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
getInt:       do forever;     say                /*keep prompting the user 'til success.*/
                              say arg(1)         /*display the prompt message to console*/
              parse pull x                       /*obtain  X,  and keep its case intact.*/
                 select
                 when x=''              then call serr "No argument was entered."
                 when words(x)>1        then call serr 'Too many arguments entered.'
                 when \datatype(x,'N')  then call serr "Argument isn't numeric:"    x
                 when \datatype(x,'W')  then call serr "Argument isn't an integer:" x

                 otherwise    return x           /* [↑]  Eureka!   Return # to invoker. */
                 end   /*select*/
              end      /*forever*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
serr:  say @  '***error*** '    arg(1);        say @  "Please try again.";          return
