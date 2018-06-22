/*REXX program obtains the cursor position (within it's window) and displays it's color.*/
parse value  cursor()  with  r  c  .             /*get cursor's location in DOS screen. */

hue=scrRead(r, c, 1, 'A')                        /*get color of the cursor's location.  */
if hue=='00'x  then color= 'black'               /*or dark grey, dark gray.             */
if hue=='01'x  then color= 'darkblue'
if hue=='02'x  then color= 'darkgreen'
if hue=='03'x  then color= 'darkturquoise'       /*or dark cyan.                        */
if hue=='04'x  then color= 'darkred'             /*or maroon.                           */
if hue=='05'x  then color= 'darkmagenta'         /*or dark pink.                        */
if hue=='06'x  then color= 'orange'              /*or dark yellow, orage, brown.        */
if hue=='07'x  then color= 'gray'                /*or grey, gray, dark white.           */
if hue=='08'x  then color= 'gray'                /*or grey, gray, dark white.           */
if hue=='09'x  then color= 'blue'                /*or bright blue.                      */
if hue=='0A'x  then color= 'green'               /*or bright green.                     */
if hue=='0B'x  then color= 'turquoise'           /*or bright turquoise, cyan, britecyan.*/
if hue=='0C'x  then color= 'red'                 /*or bright red.                       */
if hue=='0D'x  then color= 'magenta'             /*or bright magenta, pink, brite pink. */
if hue=='0E'x  then color= 'yellow'              /*or bright yellow.                    */
if hue=='0F'x  then color= 'white'               /*or bright, brite white.              */
say 'screen location ('r","c') color is:' color  /*display color of char at row, column.*/
