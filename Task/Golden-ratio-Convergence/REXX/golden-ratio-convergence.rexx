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
actualPhi=(1+sqrt(5,16))/2            /* compute the real value    */
Say 'Final value of phi  : ' phi      /* our approximation         */
Say 'Actual value        : ' actualPhi      /* the real value      */
Say 'Error (approx)      :' (phi-actualPhi) /* the difference      */
Say 'Number of iterations:' iterations
Exit

sqrt: Procedure
/* REXX *************************************************************
* Return sqrt(x,precision) -- with the specified precision
********************************************************************/
  Parse Arg x,xprec
  If x<0 Then                         /* a negative argument       */
    Return 'nan'                      /* has no real square root   */
  iprec=xprec+10                      /* increase precision        */
  Numeric Digits iprec                /* for very safe results     */
  r0= x
  r = 1                               /* start value               */
  Do Until r=r0                       /* loop until no change of r */
    r0 = r                            /* previous value            */
    r = (r + x/r) / 2                 /* next approximation        */
    End
  Numeric Digits xprec                /* reset to desired precision*/
  Return (r+0)                        /* normalize the result      */
