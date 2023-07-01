/* REXX **************************************************************
* program demonstrates  detects and handles  division by zero.
* translated from REXX:
*   removed fancy error reporting (ooRexx does not support linesize)
*   removed label Novalue (as novalue is not enabled there)
* 28.04.2013 Walter Pachl
*********************************************************************/
Signal on Syntax                   /*handle all REXX syntax errors. */
x = sourceline()                   /*being cute, x=size of this pgm.*/
y = x-x                            /*setting to zero the obtuse way.*/
z = x/y                            /* attempt to divide by 0        */
exit                               /* will not be reached           */

Syntax:
  Say 'Syntax raised in line' sigl
  Say sourceline(sigl)
  Say 'rc='rc '('errortext(rc)')'
  Exit 12
