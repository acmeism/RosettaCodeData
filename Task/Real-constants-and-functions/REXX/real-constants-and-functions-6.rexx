numeric digits ddd               /*sets the current precision to  DDD   */
numeric fuzz   fff               /*arithmetic comparisons with FFF fuzzy*/
numeric form   kkk               /*exponential: scientific | engineering*/

low=min(a,b,c,d,e,f,g, ...)      /*finds the min of specified arguments.*/
big=min(a,b,c,d,e,f,g, ...)      /*finds the max of specified arguments.*/

rrr=random(low,high)             /*gets a random integer from LOW-->HIGH*/
arr=random(low,high,seed)        /* ... with a seed (to make repeatable)*/

mzp=sign(x)                      /*finds the sign of  x   (-1, 0, +1).  */

 fs=format(x)                    /*formats X  with the current DIGITS() */
 fb=format(x,bbb)                /*            BBB  digs  before decimal*/
 fa=format(x,bbb,aaa)            /*            AAA  digs  after  decimal*/
 fa=format(x,,0)                 /*            rounds  X  to an integer.*/
 fe=format(x,,eee)               /*            exponent has eee places. */
 ft=format(x,,eee,ttt)           /*if x exceeds TTT digits, force exp.  */

hh=b2x(bbb)                      /*converts binary/bits to hexadecimal. */
dd=c2d(ccc)                      /*converts character   to decimal.     */
hh=c2x(ccc)                      /*converts character   to hexadecimal. */
cc=d2c(ddd)                      /*converts decimal     to character.   */
hh=d2x(ddd)                      /*converts decimal     to hexadecimal. */
bb=x2b(hhh)                      /*converts hexadecimal to binary (bits)*/
cc=x2c(hhh)                      /*converts hexadecimal to character.   */
dd=x2d(hhh)                      /*converts hexadecimal to decimal.     */
