/*REXX program plays (with a human) the tic-tac-toe game on an NxN grid.*/
$=copies('─',9)                        /*eyecatcher literal for messages*/
oops =$ '***error!*** ';   cell# ='cell number'   /*a couple of literals*/
sing='│─┼';    jam='║';    bar='═';    junc='╬';    dbl=jam || bar || junc
sw=linesize()-1                        /*get the width of the terminal. */
parse arg N hm cm .,@.; if N=='' then N=3; oN=N  /*specifying some args?*/
N=abs(N);   NN=N*N;   middle=NN%2+N%2  /*if N < 0,  computer goes first.*/
if N<2  then do; say oops 'tic-tac-toe grid is too small: ' N;  exit;  end
pad=copies(left('',sw%NN),1+(N<5))     /*display padding: 6x6 in 80 cols*/
if hm=='' then hm='X'; if cm==''  then cm='O' /*markers: Human, Computer*/
hm=aChar(hm,'human');  cm=aChar(cm,'computer')    /*process the markers.*/
if hm==cm  then cm='X'                 /*Human wants the "O"?   Sheesh! */
if oN<0 then call Hmove middle         /*comp moves 1st? Choose middling*/
        else call showGrid             /*···also checks for wins & draws*/
                           do  forever /*'til the cows come home, by gum*/
                           call CBLF   /*do carbon-based lifeform's move*/
                           call Hal    /*figure Hal the computer's move.*/
                           end   /*forever····showGrid does wins & draws*/
/*──────────────────────────────────ACHAR subroutine────────────────────*/
aChar: parse arg x; L=length(x)                       /*process markers.*/
if L==1                   then return x               /*1 char,  as is. */
if L==2 & datatype(x,'X') then return x2c(x)          /*2 chars, hex.   */
if L==3 & datatype(x,'W') then return d2c(x)          /*3 chars, decimal*/
say oops 'illegal character or character code for' arg(2) "marker: " x
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────CBLF subroutine─────────────────────*/
CBLF: prompt='Please enter a' cell# "to place your next marker ["hm']   (or Quit):'
  do forever;   say $ prompt;   parse pull x 1 ux 1 ox;   upper ux
  if datatype(ox,'W') then ox=ox/1      /*maybe normalize cell#: +0007. */
    select
    when abbrev('QUIT',ux,1) then call tell 'quitting.'
    when x=''                then iterate           /*Nada?   Try again.*/
    when words(x)\==1        then say oops "too many" cell# 'specified:' x
    when \datatype(x,'N')    then say oops cell# "isn't numeric: "       x
    when \datatype(x,'W')    then say oops cell# "isn't an integer: "    x
    when x=0                 then say oops cell# "can't be zero: "       x
    when x<0                 then say oops cell# "can't be negative: "   x
    when x>NN                then say oops cell# "can't exceed "        NN
    when @.ox\==''           then say oops cell# "is already occupied: " x
    otherwise                leave   /*do forever*/
    end   /*select*/
  end     /*forever*/
@.ox=hm                                /*place a  marker  for the human.*/
call showGrid                          /*and show the  tic-tac-toe grid.*/
return
/*──────────────────────────────────Hal subroutine──────────────────────*/
Hal:      select                       /*Hal will try various moves.    */
          when win(cm,N-1)   then call Hmove ,ec      /*  winning move? */
          when win(hm,N-1)   then call Hmove ,ec      /* blocking move? */
          when @.middle==''  then call Hmove middle   /*   center move. */
          when @.N.N==''     then call Hmove ,N N     /*bR corner move. */
          when @.N.1==''     then call Hmove ,N 1     /*bL corner move. */
          when @.1.N==''     then call Hmove ,1 N     /*tR corner move. */
          when @.1.1==''     then call Hmove ,1 1     /*tL corner move. */
          otherwise               call Hmove ,ac      /*some blank cell.*/
          end   /*select*/
return
/*──────────────────────────────────HMOVE subroutine────────────────────*/
Hmove: parse arg Hplace,dr dc;  if Hplace==''  then Hplace = (dr-1)*N + dc
@.Hplace=cm                            /*put marker for Hal the computer*/
say;   say  $  'computer places a marker ['cm"] at cell number "    Hplace
call showGrid
return
/*──────────────────────────────────SHOWGRID subroutine─────────────────*/
showGrid: _=0;   open=0;    cW=5;    cH=3     /*cell width, cell height.*/
do r=1 for N;  do c=1 for N; _=_+1; @.r.c=@._; open=open|@._==''; end; end
say;  z=0                                     /* [↑] create grid coörds.*/
               do     j=1  for  N             /* [↓] show grids&markers.*/
                 do   t=1  for cH;   _=;  __= /*mk is a marker in a cell*/
                   do k=1  for  N;   if t==2  then z=z+1;      mk=;    c#=
                   if t==2  then do;  mk=@.z; c#=z;  end   /*c# is cell#*/
                   _= _||jam||center(mk,cW);  __= __||jam||center(c#,cW)
                   end   /*k*/
                 say pad substr(_,2) pad translate(substr(__,2), sing,dbl)
                 end      /*t*/
              if j==N  then leave; _=
                 do b=1  for  N;   _=_||junc||copies(bar,cW);  end   /*b*/
              say pad substr(_,2) pad translate(substr(_,2),sing,dbl)
              end         /*j*/
say
if win(hm)  then  call tell 'You  ('hm")  won!"
if win(cm)  then  call tell 'The computer  ('cm")  won."
if \open    then  call tell 'This tic-tac-toe is a draw.'
return
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell: do 4; say; end;    say center(' 'arg(1)" ",sw,'─');   do 5; say; end
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────WIN subroutine──────────────────────*/
win: parse arg wm,w; if w=='' then w=N /*see if there are W # of markers*/
ac=; do   r=1  for N;  _=0;  ec=       /*see if any  rows  are a winner.*/
       do c=1  for N;  _=_+ (@.r.c==wm);  if @.r.c==''  then ec=r c;   end
     if ec\=='' then @c=ec;  if _==N | (_>=w & ec\=='')  then return 1
     end   /*r*/                       /*if w=N-1, checking for near win*/
     do   c=1  for N;  _=0; ec=        /*see if any  cols  are a winner.*/
       do r=1  for N;  _=_+ (@.r.c==wm);  if @.r.c==''  then ec=r c;   end
     if ec\=='' then @c=ec;  if _==N | (_>=w & ec\=='')  then return 1
     end   /*r*/                       /*EC is a  r,c  version of cell #*/
_=0; ec=                               /*see if winning descending diag.*/
     do d=1  for N;        _=_+ (@.d.d==wm); if @.d.d=='' then ec=d d; end
if _==N | (_>=w & ec\=='')  then return 1
_=0; ec=; r=0                          /*see if winning  ascending diag.*/
     do c=N for N by -1; r=r+1; _=_+ (@.r.c==wm); if @.r.c=='' then ec=r c
     end   /*r*/
if _==N | (_>=w & ec\=='')  then return 1
return 0
