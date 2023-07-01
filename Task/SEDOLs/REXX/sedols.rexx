/*REXX program computes the  check digit (last digit) for six or seven character SEDOLs.*/
@abcU    = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'          /*the uppercase Latin alphabet.        */
alphaDigs= '0123456789'@abcU                     /*legal characters,  and then some.    */
allowable=space(translate(alphaDigs,,'AEIOU'),0) /*remove the vowels from the alphabet. */
weights  = 1317391                               /*various weights for SEDOL characters.*/
@.=                                              /* [↓]  the ARG statement capitalizes. */
arg @.1 .                                        /*allow a user─specified  SEDOL from CL*/
if @.1==''  then do                              /*if none, then assume eleven defaults.*/
                 @.1  =  710889                  /*if all numeric, we don't need quotes.*/
                 @.2  = 'B0YBKJ'
                 @.3  =  406566
                 @.4  = 'B0YBLH'
                 @.5  =  228276
                 @.6  = 'B0YBKL'
                 @.7  =  557910
                 @.8  = 'B0YBKR'
                 @.9  =  585284
                 @.10 = 'B0YBKT'
                 @.11 = 'B00030'
                 end

      do j=1  while  @.j\=='';      sedol=@.j    /*process each of the specified SEDOLs.*/
      L=length(sedol)
      if L<6 | L>7        then call ser "SEDOL isn't a valid length"
      if left(sedol,1)==9 then call swa 'SEDOL is reserved for end user allocation'
      _=verify(sedol, allowable)
      if _\==0            then call ser 'illegal character in SEDOL:'  substr(sedol, _, 1)
      sum=0                                      /*the  checkDigit  sum  (so far).      */
              do k=1  for 6                      /*process each character in the SEDOL. */
              sum=sum + ( pos( substr(sedol, k, 1), alphaDigs) -1) * substr(weights, k, 1)
              end   /*k*/

      chkDig= (10-sum//10) // 10
      r=right(sedol, 1)
      if L==7 & chkDig\==r  then call ser sedol, 'invalid check digit:' r
      say 'SEDOL:'   left(sedol,15)      'SEDOL + check digit ───► '   left(sedol,6)chkDig
      end       /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sed:  say;  say 'SEDOL:'  sedol;          say;                          return
ser:  say;  say '***error***'   arg(1);   call sed;                     exit 13
swa:  say;  say '***warning***' arg(1);   say;                          return
