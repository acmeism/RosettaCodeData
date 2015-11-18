/*REXX program to calculate and show the Hickerson series (are near integer). */
numeric digits 250                     /*be able to calculate big factorials. */
parse arg N .                          /*get optional number of values to use.*/
if N==''  then N=18                    /*Not specified? Then use the default. */
                                       /* [+]  compute possible Hickerson #s. */
     do j=1  for N;  #=Hickerson(j)    /*traipse thru a range of Hickerson #s.*/
     t=#*10%1;       ?=right(t, 1)     /*massage number to obtain FDD past DP.*/
     if ?==0 | ?==9  then _= '(almost an integer)'            /*da number is, */
                     else _= '                   '            /* or it ain't. */
     say right(j,3) _ format(#,,5)     /*show the number with 9 decimal digits*/
     end   /*j*/                       /*FDD=1st decimal digit past dec. point*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────one─liner subroutines─────────────────────*/
!:         procedure; parse arg x; !=1;     do j=2  to x; !=!*j; end;   return !  /* ◄─── compute the factorial of X. */
Hickerson: procedure;    parse arg z;       return  !(z)  /  (2*ln2() ** (z+1))
ln2: return .6931471805599453094172321214581765680755001343602552541206800094933936219696947156058633269964186875420014,
 || 81020570685733685520235758130557032670751635075961930727570828371435190307038623891673471123350115364497955239120475
