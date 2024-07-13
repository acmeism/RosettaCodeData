/*REXX program validates International Securities ID numbers.                       */
Parse Arg z                                  /*obtain ISINs  from the C.L.          */
If z='' Then                                 /* [?]  use the default list of  ISINs */
  z='US0378331005 US0373831005 U50378331005 US03378331005',
    'US037*331005',
    'XY037833100Z AU0000XVGZA3 AU0000VXGZA3 FR0000988040'
valid='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' /*X must contain 0-->9 A-->Z           */
Do n=1 To words(z)                           /* [?]  process  all  specified  ISINs.*/
  x=word(z,n)                                /*obtain an  ISIN  from the  Z  list.  */
  p=verify(x,valid,'N')
  If p>0 Then msg='invalid character in position' p':' substr(x,p,1)
  Else Do
    dd=''                                    /* [?]  construct list of ISIN digits. */
    Do k=1 To length(x)
      _=substr(x,k,1)                        /*the ISIN may contain alphabetic chars*/
       p=pos(_,valid)                        /*X contains 0-->9 A-->Z               */
      dd=dd||p-1                             /*convert  X  string (base 36 --? dec).*/
      End
    msg=''
    Select
      When length(x)\==12            Then msg='not exactly 12 chars'
      When \datatype( left(x,2),'U') Then msg='not starting with 2 capital chars'
      When \datatype(right(x,1),'W') Then msg='last character is not a digit'
      Otherwise
         If \luhn(dd)                Then msg='does not pass the Luhn test'
      End
    End
  If msg='' Then
    Say right(x,15) '    valid'              /* display the positive message.        */
  Else
    Say right(x,15) 'not valid:' msg         /* display the problem                  */
  End   /*n*/
Exit                                         /*stick a fork in it,  we're all done   */
/*-----------------------------------------------------------------------------------*/
luhn: Procedure
  Parse Arg x                                /* get credit card number;              */
  dsum=0                                     /* zero digit sum.                      */
  y=reverse(left(0,length(x)//2)x)           /* add leading zero If needed & reverse */
  Do j=1 To length(y)-1 By 2
    _=2*substr(y,j+1,1)
    dsum=dsum+substr(y,j,1)+left(_,1)+substr(_,2,1,0)
    End
  Return right(dsum,1)==0                    /* Return 1 if number passed Luhn test  */
