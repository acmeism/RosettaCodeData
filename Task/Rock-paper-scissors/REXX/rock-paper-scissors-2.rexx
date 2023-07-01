/*REXX pgm plays rock─paper─scissors─lizard─Spock with human; tracks human usage trend. */
!= '────────';   err=! "***error***";    @.=0    /*some constants for this REXX program.*/
prompt=! 'Please enter one of:   Rock  Paper  SCissors  Lizard  SPock  (Vulcan)     (or Quit)'
$.p='paper'           ; $.s="scissors"        ; $.r='rock'          ; $.L="lizard"      ; $.v='Spock'              /*names of the thingys*/
t.p= $.r $.v          ; t.s= $.p $.L          ; t.r= $.s $.L        ; t.L= $.p $.v      ; t.v= $.r $.s             /*thingys beats stuff.*/
w.p= $.L $.s          ; w.s= $.v $.r          ; w.r= $.v $.p        ; w.L= $.r $.s      ; w.v= $.L $.p             /*stuff beats thingys.*/
b.p='covers disproves'; b.s="cuts decapitates"; b.r='breaks crushes'; b.L="eats poisons"; b.v='vaporizes smashes'  /*how the choice wins.*/
whom.1= ! 'the computer wins. ' !;     whom.2= ! "you win! " !;       win= words(t. p)

  do forever;   say;   say prompt;     say       /*prompt CBLF; then get a response.    */
  c= word($.p $.s $.r $.L $.v, random(1, 5) )    /*the computer's first choice/pick.    */
  m= max(@.r, @.p, @.s, @.L, @.v)                /*used in examining CBLF's history.    */
  if @.p==m  then c= word(w.p, random(1, 2) )    /*emulate JC's  The Amazing Karnac.    */
  if @.s==m  then c= word(w.s, random(1, 2) )    /*   "     "     "     "       "       */
  if @.r==m  then c= word(w.r, random(1, 2) )    /*   "     "     "     "       "       */
  if @.L==m  then c= word(w.L, random(1, 2) )    /*   "     "     "     "       "       */
  if @.v==m  then c= word(w.v, random(1, 2) )    /*   "     "     "     "       "       */
  c1= left(c, 1)                                 /*C1  is used for faster comparing.    */
  parse pull u;            a= strip(u)           /*obtain the CBLF's choice/pick.       */
  upper a c1  ;           a1= left(a, 1)         /*uppercase the choices, get 1st char. */
  ok=0                                           /*indicate answer isn't  OK  (so far). */
       select                                    /* [↓]  process the CBLF's choice/pick.*/
       when words(u)==0               then say err    'nothing entered.'
       when words(u)>1                then say err    'too many choices: '    u
       when abbrev('QUIT',    a)      then do; say !  'quitting.';   exit;   end
       when abbrev('LIZARD',  a)   |,
            abbrev('ROCK',    a)   |,
            abbrev('PAPER',   a)   |,
            abbrev('VULCAN',  a)   |,
            abbrev('SPOCK',   a,2) |,
            abbrev('SCISSORS',a,2)    then ok=1  /*it's a valid choice for the human.   */
       otherwise                  say err   'you entered a bad choice: '   u
       end   /*select*/

  if \ok          then iterate                   /*answer ¬OK?  Then get another choice.*/
  @.a1= @.a1 + 1                                 /*keep a history of the CBLF's choices.*/
  say ! 'computer chose: '  c
  if a1==c1  then say !  'draw.'                 /*Oh rats!  The contest ended up a draw*/
             else do who=1  for 2                /*either the computer or the CBLF won. */
                  if who==2  then parse value  a1 c1   with   c1 a1
                       do j=1  for win                                  /*see who won.  */
                       if $.a1 \== word(t.c1, j)  then iterate          /*not this 'un. */
                       say whom.who  $.c1  word(b.c1, j)  $.a1          /*notify winner.*/
                       leave                                            /*leave  J loop.*/
                       end   /*j*/
                  end        /*who*/
  end   /*forever*/                              /*stick a fork in it,  we're all done. */
