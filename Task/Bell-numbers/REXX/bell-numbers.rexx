/*REXX program calculates and displays a range of  Bell numbers  (index starts at zero).*/
parse arg LO HI .                                /*obtain optional arguments from the CL*/
if LO=='' & HI==""   then do; LO=0; HI=14;  end  /*Not specified?  Then use the default.*/
if LO=='' | LO==","  then LO=  0                 /* "      "         "   "   "     "    */
if HI=='' | HI==","  then HI= 15                 /* "      "         "   "   "     "    */
numeric digits max(9, HI*2)                      /*crudely calculate the # decimal digs.*/
!.=.;             !.0= 1;   !.1= 1;      @.= 1   /*the  FACT  function uses memoization.*/
     do j=0  for  HI+1;     $= j==0;     jm= j-1 /*JM  is used for a shortcut  (below). */
            do k=0  for j;            _= jm - k  /* [↓]  calculate a Bell # the easy way*/
            $= $ + comb(jm, k) * @._             /*COMB≡combination or binomial function*/
            end   /*k*/
     @.j= $                                      /*assign the Jth Bell number to @ array*/
     if j>=LO  &  j<=HI  then say '      Bell('right(j, length(HI) )") = "    commas($)
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _;  do c=length(_)-3  to 1  by -3; _=insert(',', _, c); end;   return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
comb: procedure expose !.; parse arg x,y;        if x==y      then  return 1
      if x-y<y  then y= x - y;                   if !.x.y\==. then  return !.x.y / fact(y)
      _= 1;          do j=x-y+1  to x;  _= _*j;  end;    !.x.y= _;  return     _ / fact(y)
/*──────────────────────────────────────────────────────────────────────────────────────*/
fact: procedure expose !.; parse arg x;    if !.x\==.   then return !.x;          != 1
                     do f=2  for x-1;      != ! * f;    end;        !.x= !;       return !
