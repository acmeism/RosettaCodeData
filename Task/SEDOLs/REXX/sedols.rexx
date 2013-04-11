/*REXX program computes the check (last) digit for  6 or 7  char SEDOLs.*/
                                      /*if the SEDOL is   6 characters, */
                                      /*a check digit is added.         */

                                      /*if the SEDOL is 7 characters, a */
                                      /*check digit is created and it is*/
                                      /*verified that it's equal to the */
                                      /*check digit already on the SEDOL*/
@.=
arg @.1 .                             /*allow a user-specified SEDOL.   */
if @.1==''  then do                   /*if none, then assume 11 defaults*/
                 @.1 = 710889
                 @.2 ='B0YBKJ'
                 @.3 = 406566
                 @.4 ='B0YBLH'
                 @.5 = 228276
                 @.6 ='B0YBKL'
                 @.7 = 557910
                 @.8 ='B0YBKR'
                 @.9 = 585284
                 @.10='B0YBKT'
                 @.11='B00030'
                 end

@abcU='ABCDEFGHIJKLMNOPQRSTUVWXYZ'     /*the uppercase Latin alphabet.  */
alphaDigs='0123456789'@abcU            /*legal chars, and then some.    */
allowable=space(translate(alphaDigs,,'AEIOU'),0)    /*remove the vowels.*/
weights=1317391                        /*various weights for SEDOL chars*/
                                       /*an alternative would be to use:*/
                                       /*  weights='1 3 1 7 3 9 1'   if */
                                       /*any weights were greater than 9*/
  do j=1  while @.j\=='';  sedol=@.j   /*process each specified SEDOL.  */
  L=length(sedol)
  if L<6 | L>7        then call ser "SEDOL isn't a valid length"
  if left(sedol,1)==9 then call swa 'SEDOL is reserved for end user allocation'
  _=verify(sedol,allowable)
  if _\==0 then call ser 'illegal character in SEDOL:' substr(sedol,_,1)
  sum=0                                /*checkDigit sum (so far).       */
          do k=1  for 6                /*process each character in SEDOL*/
          sum=sum+(pos(substr(sedol,k,1),alphaDigs)-1)*substr(weights,k,1)
          end   /*k*/

  chkDig= (10-sum//10) // 10
  r=right(sedol,1)
  if L==7 & chkDig\==r  then call ser sedol,'invalid check digit:' r
  say 'SEDOL:'  left(sedol,9)  'SEDOL + check digit:'  left(sedol,6)chkDig
  end       /*j*/

exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────subroutines──────────────────────*/
sed:  say;  say 'SEDOL:' sedol;  say;  return
ser:  say;  say '*** error! ***';  say;  say arg(1);  call sed;  exit 13
swa:  say;  say '*** warning! ***' arg(1);  say;  return
