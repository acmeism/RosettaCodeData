/*REXX program to convert decimal numbers to fractions ****************
* 15.08.2012 Walter Pachl derived from above for readability
* It took me time to understand :-) I need descriptive variable names
* Output shows where the fraction only approximates the number
* due to the limit (high) imposed on nominator and denominator
**********************************************************************/
  Numeric Digits 10               /* use "only" 10 digs of precision */
  Call test '0.9054054054','67/74'
  Call test '0.5185185185','14/27'
  Call test '0.75'        ,'3/4'
  Call test '0.905405400',' 693627417/766095958'
  Call test '0.9054054054','67/74'
  Call test '0.1428571428','1/7'
  Call test '35.000','35'
  Call test '35.001','35001/1000'
  Call test '0.00000000001','?'
  Call test '0.000001000001','1/999999'
  Exit

test:
/**********************************************************************
* Test driver for rat
**********************************************************************/
  Parse Arg d,fs                     /* number and expected fraction */
  fh=rat(d)                          /* convert number to fracrion   */
  Call o '  'd fh
  If fh<>fs Then Call o '                   not='fs
  interpret 'x='fh                   /* compute value of fraction    */
  If x<>d Then                       /* not exactly equal to number  */
    Call o '> '||x 'is different'
  Call o ' '
  Return

o: Say arg(1); Return

rat: procedure
/**********************************************************************
* rat(number<,high) returns a fraction or an integer that is equal to
* or approximately equal to number.
* Nominator and denominator must not have more than high digits
* 15.08.2012 Walter Pachl derived from Version 1
**********************************************************************/
parse arg in,high
  x=in                                 /* working copy               */
  if high=='' then
    high=10**(digits()-1)           /* maximum nominator/denominator */
  nom=0                                /* start values nominator     */
  den=1                                /*              denominator   */
  tnom=1                               /*         temp nominator     */
  tden=0                               /*         temp denominator   */
  do While tnom<=high & tden<=high     /* nominator... not too large */
    n=trunc(x)                         /* take integer part of x     */
    z=tnom;                            /* save temp nominator        */
    tnom=n*tnom+nom;                   /* compute new temp nominator */
    nom=z                              /* assign nominator           */
    z=tden;                            /* save temp denominator      */
    tden=n*tden+den                    /* compute new temp denominato*/
    den=z                              /* assign denominator         */
    if n=x | tnom/tden=in then do
      if tnom>high | tden>high then    /* temp value(s) too large    */
        Leave                          /* don't use them             */
      nom=tnom                         /* otherwise take them as     */
      den=tden                         /* final values               */
      leave                            /* and end the loop           */
      end
    x=1/(x-n)                          /* compute x for next round   */
    end
  if den=1 then return nom             /* denominator 1: integer     */
                return nom'/'den       /* otherwise a fraction       */
