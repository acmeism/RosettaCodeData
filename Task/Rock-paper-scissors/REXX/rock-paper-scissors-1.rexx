/*REXX pgm plays rock─paper─scissors with a CBLF: carbon─based life form*/
!= '────────';   err='***error!***';   @.=0       /*some pgm constants. */
prompt=! 'Please enter one of:     Rock   Paper   Scissors      (or Quit)'
$.p='paper' ;    $.s='scissors';   $.r='rock'     /*computer's choices. */
t.p=$.r     ;    t.s=$.p       ;   t.r=$.s        /*thingys beats stuff.*/
w.p=$.s     ;    w.s=$.r       ;   w.r=$.p        /*stuff beats thingys.*/
b.p='covers';    b.s='cuts'    ;   b.r='breaks'   /*how the choice wins.*/

  do forever;  say;  say prompt;  say  /*prompt the CBLF,  get response.*/
  c=word($.p $.s $.r,    random(1, 3)) /*choose the computer's 1st pick.*/
  m=max(@.r, @.p, @.s);    c=w.r       /*prepare to examine the history.*/
  if @.p==m  then c=w.p                /*emulate JC's The Amazing Karnac*/
  if @.s==m  then c=w.s                /*   "     "    "     "       "  */
  c1=left(c,1)                         /*C1  is used for fast comparing.*/
  parse pull u;       a=strip(u)       /*get the CBLF's choice (answer).*/
  upper a c1  ;      a1=left(a,1)      /*uppercase choices, get 1st char*/
  ok=0                                 /*indicate answer isn't OK so far*/
       select                          /*process the CBLF's choice.     */
       when words(u)==0           then say  err   'nothing entered'
       when words(u)>1            then say  err   'too many choices: '  u
       when abbrev('QUIT',    a)  then do;  say ! 'quitting.';  exit;  end
       when abbrev('ROCK',    a) |,
            abbrev('PAPER',   a) |,
            abbrev('SCISSORS',a)  then ok=1    /*a valid answer by CBLF.*/
       otherwise                  say err  'you entered a bad choice: '  u
       end   /*select*/

  if \ok          then iterate         /*answer ¬ OK?  Then get another.*/
  @.a1=@.a1+1                          /*keep track of CBLF's answers.  */
  say ! 'computer chose: '  c
  if a1==c1             then do;   say !  'draw.';   iterate;   end
  if $.a1==t.c1  then say  !  'the computer wins. '    !  $.c1 b.c1 $.a1
                 else say  !  'you win! '              !  $.a1 b.a1 $.c1
  end   /*forever*/
                                       /*stick a fork in it, we're done.*/
