/* REXX ---------------------------------------------------------------
* 22.06.2014 Walter Pachl using a complex data class
* ooRexx Distribution contains an elaborate complex class
* parts of which are used here
* see REXX for Extra Credit implementation
*--------------------------------------------------------------------*/
Numeric Digits 1000
Call test_integer .complex~new(1e+12,0e-3)
Call test_integer .complex~new(3.14)
Call test_integer .complex~new(1.00000)
Call test_integer .complex~new(33)
Call test_integer .complex~new(999999999)
Call test_integer .complex~new(99999999999)
Call test_integer .complex~new(1e272)
Call test_integer .complex~new(0)
Call test_integer .complex~new(1.000,-3)
Call test_integer .complex~new(1.000,-3.3)
Call test_integer .complex~new(,4)
Call test_integer .complex~new(2.00000000,+0)
Call test_integer .complex~new(,0)
Call test_integer .complex~new(333)
Call test_integer .complex~new(-1,-1)
Call test_integer .complex~new(1,1)
Call test_integer .complex~new(,.00)
Call test_integer .complex~new(,1)
Call test_integer .complex~new(0003,00.0)
Exit

test_integer:
Use Arg cpx
cpxa=left(changestr('+-',cpx,'-'),13)  -- beautify representation
Select
  When cpx~imaginary<>0 Then
    Say cpxa 'is not an integer'
  When datatype(cpx~real,'W') Then
    Say cpxa 'is an integer'
  Otherwise
    Say cpxa 'is not an integer'
  End
Return

::class complex

::method init                               /* initialize a complex number    */
expose real imaginary                       /* expose the state data          */
use Strict arg first=0, second=0            /* access the two numbers         */
real = first + 0                            /* force rounding                 */
imaginary = second + 0                      /* force rounding on the second   */

::method real                               /* return real part of a complex  */
expose real                                 /* access the state information   */
return real                                 /* return that value              */

::method imaginary                          /* return imaginary part          */
expose imaginary                            /* access the state information   */
return imaginary                            /* return the value               */

::method string                             /* format as a string value       */
expose real imaginary                       /* get the state info             */
return real'+'imaginary'i'                  /* format as real+imaginaryi      */
