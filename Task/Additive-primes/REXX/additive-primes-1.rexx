/*REXX program counts/displays the number of additive primes less than N.         */
Parse Arg n cols .                         /*get optional number of primes To find*/
If    n=='' |    n==','  Then    n= 500    /*Not specified?   Then assume default.*/
If cols=='' | cols==','  Then cols=  10    /* '      '          '     '       '   */
call genP n                                /*generate all primes under  N.        */
w=5                                        /*width of a number in any column.     */
title= 'additive primes that are  < 'commas(n)
If cols>0  Then Say ' index ¦'center(title,cols*(w+1)+1)
If cols>0  Then Say '-------+'center(''   ,cols*(w+1)+1,'-')
found=0
ol=''                                      /*a list of additive primes  (so far). */
idx=1
Do j=1 By 1
  p=p.j                                    /*obtain the  Jth  prime.              */
  If p>n Then Leave                        /* no more needed                      */
  _=sumDigs(p)
  If !._ Then Do
    found=found+1                          /*bump the count of additive primes.   */
    c=commas(p)                            /*maybe add commas To the number.      */
    ol=ol right(c,max(w,length(c)))        /*add additive prime--?list,allow big# */
    If words(ol)=10 Then Do                /* a line is complete                  */
      Say center(idx,7)'¦' substr(ol,2)    /*display what we have so far  (cols). */
      ol=''                                /* prepare for next line               */
      idx=idx+10
      End
    End
  End   /*j*/

If ol\=='' Then
  Say center(idx,7)'¦' substr(ol,2)        /*possible display residual output.    */
If cols>0  Then
  Say '--------'center('',cols*(w+1)+1,'-')
Say
Say 'found ' commas(found) title
Exit 0                                     /*stick a fork in it, we're all done.  */
/*--------------------------------------------------------------------------------*/
commas: Parse Arg ?; Do jc=length(?)-3 To 1 by -3; ?=insert(',',?,jc); End; Return ?
sumDigs:Parse Arg x 1 s 2; Do k=2 For length(x)-1; s=s+substr(x,k,1); End;  Return s
/*--------------------------------------------------------------------------------*/
genP:
  Parse Arg n
  pl=2 3 5 7 11 13
  !.=0
  Do np=1 By 1 While pl<>''
    Parse Var pl p pl
    p.np=p
    sq.np=p*p
    !.p=1
    End
  np=np-1
  Do j=p.np+2 by 2 While j<n
    Parse Var j '' -1 _                    /*obtain the last digit of the  J  var.*/
    If _==5  Then Iterate
    If j// 3==0 Then Iterate
    If j// 7==0 Then Iterate
    If j//11==0 Then Iterate
    Do k=6 By 1 While sq.k<=j              /*divide J by other primes <=sqrt(j)   */
      If j//p.k==0 Then Iterate j          /* not prime - try next                */
      End   /*k*/
    np=np+1                                /*bump prime count; assign prime & flag*/
    p.np=j
    sq.np=j*j
    !.j=1
    End   /*j*/
  Return
