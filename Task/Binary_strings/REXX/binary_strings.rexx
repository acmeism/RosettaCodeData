/*REXX program shows ways to use and express  binary strings.           */

dingsta='11110101'b                    /*4 versions, bit str assignment.*/
dingsta="11110101"b                    /*same as above.                 */
dingsta='11110101'B                    /*same as above.                 */
dingsta='1111 0101'B                   /*same as above.                 */

dingst2=dingsta                        /*clone 1 str to another (copy). */

other='1001 0101 1111 0111'b           /*another binary (bit) string.   */

if dingsta=other then say 'they are equal'        /*compare two strings.*/

if other==''        then say 'OTHER is empty.'    /*see if it's empty.  */
if length(other)==0 then say 'OTHER is empty.'    /*another version.    */

otherA=other || '$'                    /*append a dollar sign to OTHER. */
otherB=other'$'                        /*same as above, with less fuss. */

guts=substr(c2b(other),10,3)           /*get the 10th through 12th bits.*/
                                       /*see sub below.   Some REXXes   */
                                       /*have C2B as a built-in function*/

new=changestr('A',other,"Z")           /*change the letter  A  to  Z.   */

tt=changestr('~~',other,";")           /*change 2 tildes to a semicolon.*/

joined=dignsta || dingst2              /*join 2 strs together (concat). */
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────C2B subroutine───────────────────────*/
c2b: return x2b(c2x(arg(1))) /*return the string as a binary string.    */
