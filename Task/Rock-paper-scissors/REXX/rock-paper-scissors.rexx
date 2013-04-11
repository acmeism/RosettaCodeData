/*REXX pgm plays rock-paper-scissors with a CBLF (carbon-based life form*/
!='────────';   er='***error!***'; @.=0         /*some constants for pgm*/
z=! 'Please enter one of:     Rock  Paper  Scissors      (or Quit)'
$.p='paper';    $.s='scissors';    $.r='rock'     /*computer's choices. */
b.p=' covers '; b.s=' cuts ';      b.r=' breaks ' /*how the choice wins.*/

  do forever;   say;    say z;    say  /*prompt the CBLF & get response.*/
  c=word('rock paper scissors',random(1,3))    /*the computer's 1st pick*/
  m=max(@.r,@.p,@.s);   f='paper'      /*prepare to examine the history.*/
  if @.p==m  then f='scissors'         /*emulate JC's The Amazing Karnac*/
  if @.s==m  then f='rock'             /*   "     "    "     "       "  */
  if m\==0   then c=f                  /*choose based on CBLF's history.*/
  c1=left(c,1);   upper c1             /*C1  is used for fast comparing.*/
  parse pull u;   a=strip(u);          /*get the CBLF's choice (answer).*/
  upper a;        a1=left(a,1)         /*uppercase answer, get 1st char.*/
  ok=0                                 /*indicate answer isn't OK so far*/
       select                          /*process the CBLF's choice.     */
       when words(u)==0           then say  er  'nothing entered'
       when words(u)>1            then say  er  'too many choices: '  u
       when abbrev('QUIT',a)      then do;  say ! 'quitting.';  exit;  end
       when abbrev('ROCK',a)  |,
            abbrev('PAPER',a) |,
            abbrev('SCISSORS',a)  then ok=1    /*a valid answer by CBLF.*/
       otherwise                  say er  'you entered a bad choice:'  u
       end   /*select*/

  if \ok          then iterate         /*answer ¬ OK?  Then get another.*/
  @.a1 = @.a1+1                        /*keep track of CBLF's answers.  */
  say ! 'computer chose: '  c
  if a1==c1              then do; say ! 'draw.';  iterate;  end
  if a1=='R' & c1=='S' |,
     a1=='S' & c1=='P' |,
     a1=='P' & c1=='R'  then say ! 'you win! '            ! $.a1 b.a1 $.c1
                        else say ! 'the computer wins. '  ! $.c1 b.c1 $.a1
  end   /*forever*/
                                       /*stick a fork in it, we're done.*/
