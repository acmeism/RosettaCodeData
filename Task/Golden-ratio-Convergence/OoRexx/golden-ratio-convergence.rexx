/* REXX
* Compute the Golden Ratio using iteration
* 20230604 Walter Pachl
*/
Numeric Digits 16
Parse Value '1 1 1e-5' With oldPhi phi limit
Do iterations=1 By 1 Until delta<=limit
  phi=1+1/oldPhi                      /* next approximation        */
  delta=abs(phi-oldPhi)               /* difference to previous    */
  If delta>limit Then                 /* not small enough          */
    oldPhi=phi                        /* proceed with new value    */
  End
actualPhi=(1+rxCalcsqrt(5,16))/2       /* compute the real value    */
Say 'Final value of phi  : ' phi      /* our approximation         */
Say 'Actual value        : ' actualPhi      /* the real value      */
Say 'Error (approx)      :' (phi-actualPhi) /* the difference      */
Say 'Number of iterations:' iterations
Exit
::REQUIRES RXMATH library
