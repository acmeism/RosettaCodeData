/*REXX program demonstrates REXX's ability to handle non-decimal radices*/
/*┌────────────────────────────────────────────────────────────────────┐
┌─┘ In REXX, there are no numeric-type variables (integer, float, real,└─┐
│ logical, complex, double, etc), only  character.  Everything is stored │
│ as a character string.  Arithmetic is done almost exactly the way a    │
│ schoolchild would perform it.  To add, align the two numbers up (right │
│ justified, with the decimal being the pivot) and simply add the columns│
│ up, noting carries and the signs.  Multiplication and division are     │
└─┐ simarily performed.                                                ┌─┘
  └────────────────────────────────────────────────────────────────────┘*/
a=123                        /*all of these assignments are identical:  */
b='123'                      /*there is no difference in the assignments*/
c='1' || "2" || '3'
d= 1  ||  2  ||  3
e= 12        ||  3
f=120 + 3
g=substr(9912388,3,2)
h=left(123456,3)
i=right(777.123,3)
j=12 + '     3   '
k=0000000123.0000/1          /*divison "normalizes the number (───► 123)*/

                             /*parsing then, of a decimal number is no  */
                             /*different then parsing a character string*/
                             /*because decimal numbers  ARE  character  */
                             /*strings.    As such, numbers may have    */
                             /*leading and/or trailing blanks, and in   */
                             /*some cases, imbedded blanks (after any   */
                             /*leading sign).                           */

aa=' 123 '                   /*AA's  exact value is different the  A,   */
                             /*but it's numerically equal to  A.        */
bb=123.                      /*the same can be said for the rest of 'em.*/
cc=+123
dd=' +  123'
ee=0000123
ff=1.23e+1
gg=001.23E0002
hh=1230e-1
ii=122.999999999999999999999999999999999    /*assuming NUMERIC DIGITS 9 */
jj= +++123
kk= - -123

bingoA='10101'b               /*stores a binary value. */
bingoB='10101'B               /*  B  can be uppercase. */
bingoC='1 0101'b              /*apostrophes may be used*/
bingoD="1 0101"b              /*quotes may be used.    */

hyoidA='deadbeaf'x            /*stores a hexadecimal value.*/
hyoidB="deadbeaf"X
hyoidC='dead beaf'X
hyoidD='de ad be af'X
hyoidE='dead be af'X
hyoidF='7abc'x
                              /*REXX has several built-in functions     */
                              /*(BIFs) to handle conversions of the     */
                              /*above-mentioned "number" formats.       */

cyanA=d2x(a)                  /*converts a decimal string to hexadecimal*/
cyanB=d2x(5612)               /*converts a decimal string to hexadecimal*/

cyanD=b2x(101101)             /*converts a binary  string to hexadecimal*/

cyanE=b2c(101101)             /*some REXXes support this, others don't. */
cyanF=c2b('copernicium')      /*some REXXes support this, others don't. */

cyanG=c2d('nilla')            /*converts a character string to decimal. */
cyanH=d2c(251)                /*converts a decimal number to character. */

cyanI=x2d(fab)                /*converts a hexadcimal string to decinal.*/
cyanJ=x2c(fab)                /*converts a hexadcimal string to chars.  */
cyanK=x2b(fab)                /*converts a hexadcimal string to binary. */

befog=d2b(144)                /*there's no dec──►binary,  but see below.*/
unfog=b2d(101)                /*there's no bin──►decimal, but see below.*/

  do j=0  to 27               /*show some simple low-value conversions. */
  say right(j,2) 'in decimal is' d2b(j) "in binary and" d2x(j) 'in hex.'
  end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────add these subroutines to end─of─program.  */
d2b: return word(strip(x2b(d2x(arg(1))),'L',0) 0,1)  /*convert dec──►bin*/
b2d: return x2d(b2x(arg(1)))                         /*convert bin──►dec*/
b2c: return x2c(b2x(arg(1)))                         /*convert bin──►chr*/
c2b: return word(strip(x2b(c2x(arg(1))),'L',0) 0,1)  /*convert chr──►bin*/
