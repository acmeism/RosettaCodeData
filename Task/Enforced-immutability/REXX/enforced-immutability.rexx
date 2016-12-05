/*REXX program  emulates  immutable variables  (as a post-computational check).         */
call immutable '$=1'                             /* ◄─── assigns an immutable variable. */
call immutable '   pi = 3.14159'                 /* ◄───    "     "     "         "     */
call immutable 'radius= 2*pi/4 '                 /* ◄───    "     "     "         "     */
call immutable '     r=13/2    '                 /* ◄───    "     "     "         "     */
call immutable '     d=0002 * r'                 /* ◄───    "     "     "         "     */
call immutable ' f.1  = 12**2  '                 /* ◄───    "     "     "         "     */

say '       $ ='  $                              /*show the variable, just to be sure.  */
say '      pi ='  pi                             /*  "   "      "       "   "  "   "    */
say '  radius ='  radius                         /*  "   "      "       "   "  "   "    */
say '       r ='  r                              /*  "   "      "       "   "  "   "    */
say '       d ='  d                              /*  "   "      "       "   "  "   "    */

                    do radius=10  to  -10  by -1 /*perform some faux important stuff.   */
                    circum=$*pi*2*radius         /*some kind of impressive calculation. */
                    end   /*k*/                  /* [↑]  that should do it, by gum.     */
call immutable                                   /* ◄═══ see if immutable variables OK. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
immutable: if symbol('immutable.0')=='LIT'  then immutable.0= /*1st time see immutable? */
           if arg()==0 then do                                /* [↓]  chk all immutables*/
                              do __=1  for words(immutable.0); _=word(immutable.0,__)
                              if value(_)==value('IMMUTABLE.!'_)  then iterate   /*same?*/
                              call ser -12, 'immutable variable  ' _ "  compromised."
                              end   /*__*/                  /* [↑]  Error?  ERRmsg, exit*/
                            return 0                        /*return and indicate  A-OK.*/
                            end                             /* [↓] immutable must have =*/
           if pos('=',arg(1))==0  then call ser -4, "no equal sign in assignment:"  arg(1)
           parse arg _ '=' __;         upper _;    _=space(_)    /*purify variable name.*/
           if symbol("_")=='BAD'  then call ser -8,_ "isn't a valid variable symbol."
           immutable.0=immutable.0 _                        /*add immutable var to list.*/
           interpret '__='__;     call value _,__           /*assign value to a variable*/
           call value 'IMMUTABLE.!'_,__                     /*assign value to bkup var. */
           return words(immutable.0)                        /*return number immutables. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ser:       say;     say '***error***'  arg(2);     say;     exit arg(1)     /*error msg.*/
