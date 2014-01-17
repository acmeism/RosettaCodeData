/*REXX pgm emulates immutable variables (as a post-computational check).*/
call immutable '$=1'                   /* ◄─── assigns an immutable var.*/
call immutable '   pi = 3.14159'       /* ◄───    "     "     "      "  */
call immutable 'radius= 2*pi/4 '       /* ◄───    "     "     "      "  */
call immutable '     r=13/2    '       /* ◄───    "     "     "      "  */
call immutable '     d=0002 * r'       /* ◄───    "     "     "      "  */
call immutable ' f.1  = 12**2  '       /* ◄───    "     "     "      "  */

say '       $ ='  $                    /*show variable, just to be sure.*/
say '      pi ='  pi                   /*  "      "       "   "  "   "  */
say '  radius ='  radius               /*  "      "       "   "  "   "  */
say '       r ='  r                    /*  "      "       "   "  "   "  */
say '       d ='  d                    /*  "      "       "   "  "   "  */

                      do radius=10  to  -10  by -1  /*perform some stuff*/
                      circum=$*pi*2*radius          /*some kind of calc.*/
                      end   /*k*/                   /*that should do it.*/
call immutable                         /* ◄═══ check if immutables  OK. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────IMMUTABLE subroutine────────────────*/
immutable: if symbol('immutable.0')=='LIT'  then immutable.0= /*1st time*/
if arg()==0 then do                    /* [↓]  check all immutable vars.*/
                   do __=1  for words(immutable.0); _=word(immutable.0,__)
                   if value(_)==value('IMMUTABLE.!'_)  then iterate  /*same?*/
                   call ser -12, 'immutable variable  ' _ "  compromised."
                   end   /*__*/        /* [↑]  if an error, ERRmsg, exit*/
                 return 0              /*return to invoker, indicate OK.*/
                 end                   /* [↓]  immutable var must have =*/
if pos('=',arg(1))==0  then call ser -4, 'no equal sign in assignment:' arg(1)
parse arg _ '=' __;         upper _;    _=space(_)    /*purify var name.*/
if symbol('_')=='BAD'  then call ser -8,_ "isn't a valid variable symbol."
immutable.0=immutable.0 _              /*add immutable var to the list. */
interpret '__='__;     call value _,__ /*assign a value to a variable.  */
call value 'IMMUTABLE.!'_,__           /*also, assign value to bkup. var*/
return words(immutable.0)              /*return the # of immutable vars.*/
/*──────────────────────────────────SER subroutine──────────────────────*/
ser:  say;   say '***error!***' arg(2);   say;   exit arg(1)   /*ERRmsg.*/
