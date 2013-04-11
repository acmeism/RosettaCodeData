/*REXX program to test if a variable is defined. */

tlaloc = "rain god of the Aztecs."


                    /*check if the rain god is defined.*/
y='tlaloc'
if symbol(y)=="VAR" then say y 'is defined.'
                    else say y "ain't defined."


                    /*check if the fire god is defined.*/

y='xiuhtecuhtli'
if symbol(y)=="VAR" then say y 'is defined.'
                    else say y "ain't defined."


drop tlaloc         /*un-define the  TLALOC  variable. */
                    /*check if the rain god is defined.*/
y='tlaloc'
if symbol(y)=="VAR" then say y 'is defined.'
                    else say y "ain't defined."
