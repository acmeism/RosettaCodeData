/*REXX program to test range extraction. ******************************
* 07.08.2012 Walter Pachl
**********************************************************************/
aaa='0 1 2 4 6 7 8 11 12 14 15 16 17 18 19 20 21 22 23 24 25 27 28 29',
    '30 31 32 33 35 36 37 38 39'
say 'old='aaa;
aaa=aaa 1e99                        /* artificial number at the end  */
i=0                                 /* initialize index              */
ol=''                               /* initialize output string      */
comma=''                            /* will become a ',' lateron     */
inrange=0
Do While i<=words(aaa)              /* loop for all numbers          */
  i=i+1                             /* index of next number          */
  n=word(aaa,i)                     /* the now current number        */
  If n=1e99 Then Leave              /* we are at the end             */
  If inrange Then Do                /* range was opened              */
    If word(aaa,i+1)<>n+1 Then Do   /* following word not in range   */
      ol=ol||n                      /* so this number is the end     */
      inrange=0                     /* and the range is over         */
      End                           /* else ignore current number    */
    End
  Else Do                           /* not in a range                */
    ol=ol||comma||n                 /* add number (with comma)       */
    comma=','                       /* to the output string          */
    If word(aaa,i+2)=n+2 Then Do    /* if the nr after the next fits */
      inrange=1                     /* open a range                  */
      ol=ol'-'                      /* append the range connector    */
      End
    End
  End
Say 'new='ol
