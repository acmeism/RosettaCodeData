prompt=! 'Please enter one of:   Rock  Paper  SCissors  Lizard  SPock  (Vulcan)     (or Quit)'
$.p='paper'           ; $.s='scissors'        ; $.r='rock'          ; $.l='lizard'      ; $.v='Spock'              /*names of the thingys*/
t.p= $.r $.v          ; t.s= $.p $.l          ; t.r= $.s $.l        ; t.l= $.p $.v      ; t.v= $.r $.s             /*thingys beats stuff.*/
w.p= $.l $.s          ; w.s= $.v $.r          ; w.r= $.v $.p        ; w.l= $.r $.s      ; w.v= $.l $.p             /*stuff beats thingys.*/
b.p='covers disproves'; b.s='cuts decapitates'; b.r='breaks crushes'; b.l='eats poisons'; b.v='vaporizes smashes'  /*how the choice wins.*/
whom.1=! 'the computer wins. ' !;  whom.2=! 'you win! ' !;  win=words(t.p)

  do forever;  say;  say prompt;   say     /*prompt CBLF & get response.*/
  c=word($.p $.s $.r $.l $.v',random(1,5)) /*the computer's first pick. */
  m=max(@.r,@.p,@.s,$.l,$.v)               /*prepare to examine history.*/
  if @.p==m  then c=word(w.p,random(1,2))  /*emulate The Amazing Karnac.*/
  if @.s==m  then c=word(w.s,random(1,2))  /*   "     "     "       "   */
  if @.r==m  then c=word(w.r,random(1,2))  /*   "     "     "       "   */
  if @.l==m  then c=word(w.l,random(1,2))  /*   "     "     "       "   */
  if @.v==m  then c=word(w.v,random(1,2))  /*   "     "     "       "   */
  c1=left(c,1)                         /*C1  is used for fast comparing.*/
  parse pull u;    a=strip(u)          /*get the CBLF's choice (answer).*/
  upper a c1  ;   a1=left(a,1)         /*uppercase choices, get 1st char*/
  ok=0                                 /*indicate answer isn't OK so far*/
       select                          /*process the CBLF's choice.     */
       when words(u)==0              then say err   'nothing entered.'
       when words(u)>1               then say err   'too many choices: ' u
       when abbrev('QUIT',    a)     then do; say ! 'quitting.'; exit; end
       when abbrev('LIZARD',  a)   |,
            abbrev('ROCK',    a)   |,
            abbrev('PAPER',   a)   |,
            abbrev('Vulcan',  a)   |,
            abbrev('SPOCK',   a,2) | ,
            abbrev('SCISSORS',a,2)   then ok=1    /*a valid CBLF answer.*/
       otherwise                 say err   'you entered a bad choice: '  u
       end   /*select*/

  if \ok  then iterate                 /*answer ¬ OK?  Then get another.*/
  @.a1=@.a1+1                          /*keep track of CBLF's answers.  */
  say ! 'computer chose: '  c
  if a1==c1  then do;   say !  'draw.';   iterate;   end

                              do who=1  for 2   /*either computer | CBLF*/
                              if who==2  then parse value a1 c1 with c1 a1
                                 do j=1  for win
                                 if $.a1\==word(t.c1,j)  then iterate
                                 say whom.who $.c1 word(b.c1,j) $.a1
                                 leave
                                 end   /*j*/
                              end      /*who*/
  end   /*forever*/
                                       /*stick a fork in it, we're done.*/
