/*REXX program validates the  checksum digit for an  International Securities ID number.*/
parse arg z                                      /*obtain optional  ISINs  from the C.L.*/
if z=''  then z= "US0378331005 US0373831005 U50378331005 US03378331005 AU0000XVGZA3" ,
                 'AU0000VXGZA3 FR0000988040'     /* [↑]  use the default list of  ISINs.*/
                                                 /* [↓]  process  all  specified  ISINs.*/
     do n=1  for words(z);  x=word(z, n);  y= x  /*obtain an  ISIN  from the  Z  list.  */
     $=                                          /* [↓]  construct list of ISIN digits. */
        do k=1  for length(x);  _= substr(x,k,1) /*the ISIN may contain alphabetic chars*/
        p= pos(_, 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ)   /*X must contain A──►Z, 0──►9.*/
        if p==0  then y=                                  /*trigger  "not"  valid below.*/
                 else $= $ || p-1                /*convert  X  string (base 36 ──► dec).*/
        end   /*k*/                              /* [↑]  convert  alphabetic ──► digits.*/
     @=                                          /*placeholder for the "not" in message.*/
     if length(y)\==12             then @= "not" /*see if the ISIN is exactly 12 chars. */
     if \datatype( left(x,2),'U')  then @= "not" /* "   "  "    "  1st 2 chars cap. let.*/
     if \datatype(right(x,1),'W')  then @= "not" /* "   "  "    "  last char not a digit*/
     if @==''  then  if \luhn($)   then @= "not" /* "   "  "    "  passed the Luhn test.*/
     say right(x, 30)   right(@, 5)   "valid"    /*display the   yea  or  nay   message.*/
     end   /*n*/                                 /* [↑] 1st 3 IFs could've been combined*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Luhn: procedure;  parse arg x;           $= 0    /*get credit card number;  zero $ sum. */
      y= reverse( left(0, length(x) // 2)x)      /*add leading zero if needed, & reverse*/
                            do j=1  to length(y)-1  by 2;    _= 2  *  substr(y, j+1, 1)
                            $= $ + substr(y, j, 1)  +  left(_, 1)  +  substr(_, 2  , 1, 0)
                            end   /*j*/          /* [↑]   sum the  odd and even  digits.*/
      return right($, 1)==0                      /*return "1" if number passed Luhn test*/
