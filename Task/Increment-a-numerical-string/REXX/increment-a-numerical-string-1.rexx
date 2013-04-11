count = "3"           /*typeless variables are all character strings.*/
count = 3             /*(same as above)*/
count = count + 1     /*variables in a numerical context are treated as numbers.*/
say count

/*------------------ The default numeric digits for REXX is 9 digits.   */
/*------------------ However, that can be increased with NUMERIC DIGITS.*/

numeric digits 15000   /*let's go ka-razy with fifteen thousand digits. */

count=copies(2,15000)  /*stressing REXX's brains with lots of  two's,   */
                       /*the above is considered a number in REXX.      */
count=count+3          /*make that last digit a "five".                 */

say  'count='  count   /*ya most likely don't want to display this thing*/
