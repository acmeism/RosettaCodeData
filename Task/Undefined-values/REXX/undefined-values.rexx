/*REXX program test if a (REXX)  variable is  defined  or  not defined.       */
tlaloc = "rain god of the Aztecs."     /*assign a value to the Aztec rain god.*/
                                       /*check if the  rain god  is defined.  */
y= 'tlaloc'
if symbol(y)=="VAR"  then say y  ' is   defined.'
                     else say y  "isn't defined."

                                       /*check if the  fire god  is defined.  */

y= 'xiuhtecuhtli'                      /*assign a value to the Aztec file god.*/
if symbol(y)=="VAR"  then say y  ' is   defined.'
                     else say y  "isn't defined."


drop tlaloc                            /*un─define the  TLALOC  REXX variable.*/
                                       /*check if the  rain god  is defined.  */
y= 'tlaloc'
if symbol(y)=="VAR"  then say y  ' is  defined.'
                     else say y  "isn't defined."
                                       /*stick a fork in it,  we're all done. */
