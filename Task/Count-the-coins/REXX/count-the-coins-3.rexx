/*REXX program counts the number of ways to make change with coins from an given amount.*/
numeric digits 20                                /*be able to handle large amounts of $.*/
parse arg N $                                    /*obtain optional arguments from the CL*/
if N='' | N=","    then N=100                    /*Not specified?  Then Use $1  (≡100¢).*/
if $='' | $=","    then $=1 5 10 25              /*Use penny/nickel/dime/quarter default*/
X=N                                              /*save original for possible error msgs*/
if left(N,1)=='$'  then do                       /*the amount has a leading dollar sign.*/
                        _=substr(N,2)            /*the amount was specified in  dollars.*/
                        if \isNum(_)  then call ser  "amount isn't numeric: "   N
                        N=100*_                  /*change amount (in $) ───►  cents (¢).*/
                        end
max$=10**digits()                                /*the maximum amount this pgm can have.*/
if \isNum(N)  then call  ser  X   " amount isn't numeric."
if N=0        then call  ser  X   " amount can't be zero."
if N<0        then call  ser  X   " amount can't be negative."
if N>max$     then call  ser  X   " amount can't be greater than " max$'.'
coins=words($);  !.=.;   NN=N;   p=0             /*#coins specified; coins; amount; prev*/
@.=0                                             /*verify a coin was only specified once*/
          do j=1  for coins                      /*create a fast way of accessing specie*/
          _=word($,j);     ?=_ ' coin'           /*define an array element for the coin.*/
          if _=='1/2'  then _=.5                 /*an alternate spelling of a half-cent.*/
          if _=='1/4'  then _=.25                /* "     "         "     " " quarter-¢.*/
          if \isNum(_) then call ser ? "coin value isn't numeric."
          if _<0       then call ser ? "coin value can't be negative."
          if _<=0      then call ser ? "coin value can't be zero."
          if @._       then call ser ? "coin was already specified."
          if _<p       then call ser ? "coin must be greater than previous:"    p
          if _>N       then call ser ? "coin must be less or equal to amount:"  X
          @._=1;  p=_                            /*signify coin was specified; set prev.*/
          $.j=_                                  /*assign the value to a particular coin*/
          end   /*j*/
_=n//100;                          cnt=' cents'  /* [↓]  is the amount in whole dollars?*/
if _=0  then do; NN='$' || (NN%100);  cnt=;  end /*show the amount in dollars, not cents*/
say 'with an amount of '      commas(NN)cnt",  there are "       commas( MKchg(N, coins) )
say 'ways to make change with coins of the following denominations: '    $
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isNum:  return datatype(arg(1), 'N')             /*return 1 if arg is numeric, 0 if not.*/
ser:    say;   say '***error***';   say;   say arg(1);   say;   exit 13     /*error msg.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: procedure;  parse arg _;           n=_'.9';     #=123456789;     b=verify(n,#,"M")
        e=verify(n,#'0',,verify(n,#"0.",'M'))-4
                    do j=e  to b  by -3;   _=insert(',',_,j);    end  /*j*/;      return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
MKchg:  procedure expose $. !.;  parse arg a,k               /*function is recursive.   */
        if !.a.k\==. then return !.a.k                       /*found this A & K before? */
        if a==0      then return 1                           /*unroll for a special case*/
        if k==1      then return 1                           /*   "    "  "    "      " */
        if k==2  then f=1                                    /*handle this special case.*/
                 else f=MKchg(a, k-1)                        /*count, recurse the amount*/
        if a==$.k    then do; !.a.k=f+1; return !.a.k; end   /*handle this special case.*/
        if a <$.k    then do; !.a.k=f  ; return f    ; end   /*   "     "     "      "  */
        !.a.k=f + MKchg(a-$.k, k);       return !.a.k        /*compute, define, return. */
