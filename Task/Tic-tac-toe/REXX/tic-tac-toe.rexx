/*REXX program plays  (with a human)  the   tic─tac─toe   game  on an  NxN  grid.       */
$=copies('─', 9)                                 /*eyecatcher literal for error messages*/
oops =$ '***error*** ';    cell@ ="cell number"  /*a couple of literals for some  SAYs. */
sing='│─┼';    jam="║";    bar='═';     junc="╬";         dbl=jam || bar || junc
sw=linesize() - 1                                /*obtain width of the terminal (less 1)*/
parse arg N hm cm .,@.                           /*obtain optional arguments from the CL*/
if N=='' | N==","  then N=3;   oN=N              /*N  not specified?   Then use default.*/
N=abs(N);   NN=N*N;   middle=NN%2+N%2            /*if N < 0,  then computer goes first. */
if N<2  then do; say oops  'tic─tac─toe grid is too small: '  N;     exit;   end
pad=left('', sw%NN)                              /*display padding:  6x6  in 80 columns.*/
if hm=='' then hm="X";  if cm==''  then cm="O"   /*define  the markers:  Human, computer*/
hm=aChar(hm,'human');   cm=aChar(cm,'computer')  /*process/define markers for players.  */
parse upper value hm cm with uh uc               /*use uppercase values is markers:  X x*/
if uh==uc  then cm=word('O X', 1 + (uh=="O") )   /*The human wants Hal's marker?  Swap. */
if oN<0 then call Hmove middle                   /*Hal moves first? Then choose middling*/
        else call showGrid                       /*showGrid also checks for wins & draws*/
                            do  forever          /*'til the cows come home  (or  QUIT). */
                            call CBLF            /*process carbon-based lifeform's move.*/
                            call Hal             /*determine Hal's  (the computer) move.*/
                            end   /*forever*/    /*showGrid subroutine does wins & draws*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
ab:    parse arg bx; if bx\==' '  then return bx /*test if the  marker  isn't  a  blank.*/
       say oops 'character code for'     whoseX     "marker can't be a blank."
       exit                                      /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
aChar: parse arg x,whoseX;  L=length(x)                               /*process markers.*/
       if L==1                   then return ab(x)                    /*1 char,  as is. */
       if L==2 & datatype(x,'X') then return ab(x2c(x))               /*2 chars, hex.   */
       if L==3 & datatype(x,'W') then return ab(d2c(x))               /*3 chars, decimal*/
       say oops 'illegal character or character code for'  whoseX  "marker: "   x
       exit                                      /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
CBLF : prompt='Please enter a'    cell@    "to place your next marker ["hm']   (or Quit):'
         do forever;   say $ prompt;     parse pull x 1 ux 1 ox;    upper ux
         if datatype(ox,'W') then ox=ox/1        /*maybe normalize cell number:  +0007. */
           select
           when abbrev('QUIT',ux,1) then call tell 'quitting.'
           when x=''                then iterate                     /*Nada?  Try again.*/
           when words(x)\==1        then say oops "too many" cell#  'specified:'   x
           when \datatype(x,'N')    then say oops cell@   "isn't numeric: "        x
           when \datatype(x,'W')    then say oops cell@  "isn't an integer: "      x
           when x=0                 then say oops cell@  "can't be zero: "         x
           when x<0                 then say oops cell@  "can't be negative: "     x
           when x>NN                then say oops cell@  "can't exceed "           NN
           when @.ox\==''           then say oops cell@  "is already occupied: "   x
           otherwise                leave  /*forever*/
           end   /*select*/
         end     /*forever*/
       @.ox=hm                                   /*place a marker for the human (CLBF). */
       call showGrid                             /*and display the  tic─tac─toe  grid.  */
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
Hal:           select                                        /*Hal tries various moves. */
               when win(cm,N-1)   then call Hmove , ec       /*is this the winning move?*/
               when win(hm,N-1)   then call Hmove , ec       /* "   "   a blocking   "  */
               when @.middle==''  then call Hmove middle     /*pick the  center  move.  */
               when @.N.N==''     then call Hmove , N N      /*bottom right corner move.*/
               when @.N.1==''     then call Hmove , N 1      /*   "    left    "     "  */
               when @.1.N==''     then call Hmove , 1 N      /*  top  right    "     "  */
               when @.1.1==''     then call Hmove , 1 1      /*   "    left    "     "  */
               otherwise               call Hmove , ac       /*pick a  blank  cell   "  */
               end   /*select*/
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
Hmove: parse arg Hplace,dr dc;    if Hplace==''  then Hplace = (dr-1)*N  +  dc
       @.Hplace=cm                                           /*place computer's marker. */
       say;  say  $   'computer places a marker  ['cm"]  at"     cell@      ' '     Hplace
       call showGrid
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showGrid: _=0;   open=0;    cW=5;    cH=3                    /*cell width,  cell height.*/
           do r=1 for N;  do c=1 for N; _=_+1; @.r.c=@._; open=open|@._==''; end
           end   /*r*/
       say                                                   /* [↑]  create grid coörds.*/
       z=0;          do     j=1  for  N                      /* [↓]  show grids&markers.*/
                       do   t=1  for cH;    _=;  __=         /*MK is a marker in a cell.*/
                         do k=1  for  N;    if t==2  then z=z+1;      mk=;    c#=
                         if t==2  then do;  mk=@.z;  c#=z;  end      /*c# is cell number*/
                         _= _||jam||center(mk,cW);   __= __ || jam || center(c#, cW)
                         end   /*k*/
                       say pad substr(_,2) pad translate(substr(__,2), sing,dbl)
                       end     /*t*/
                     if j==N  then leave;  _=
                       do b=1  for  N;    _=_ || junc || copies(bar, cW);  end  /*b*/
                     say pad  substr(_,2)  pad  translate(substr(_,2), sing, dbl)
                     end        /*j*/
       say
       if win(hm)  then  call tell  'You  ('hm")  won!"
       if win(cm)  then  call tell  'The computer  ('cm")  won."
       if \open    then  call tell  'This tic─tac─toe game is a draw.'
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell:    do 4; say; end;     say center(' 'arg(1)" ", sw, '─');     do 5; say; end;   exit
/*──────────────────────────────────────────────────────────────────────────────────────*/
win:   parse arg wm,w;    if w==''  then w=N             /*see if there are W of markers*/
      ac=; do   r=1  for N;  _=0;  ec=                   /*see if any  rows are a winner*/
             do c=1  for N;  _=_+ (@.r.c==wm);   if @.r.c==''  then ec=r c;   end
           if ec\=='' then ac=ec;  if _==N | (_>=w & ec\=='')  then return 1
           end   /*r*/                                   /*w=N-1?  Checking for near win*/
           do   c=1  for N;  _=0; ec=                    /*see if any  cols are a winner*/
             do r=1  for N;  _=_+ (@.r.c==wm);   if @.r.c==''  then ec=r c;   end
           if ec\=='' then ac=ec;  if _==N | (_>=w & ec\=='')  then return 1
           end   /*r*/                                   /*EC is a R,C version of cell #*/
      _=0; ec=                                           /*A winning descending diag. ? */
           do d=1  for N;        _=_+ (@.d.d==wm);  if @.d.d=='' then ec=d d; end
      if _==N | (_>=w & ec\=='')  then return 1
      _=0; ec=; r=0                                      /*A winning ascending diagonal?*/
           do c=N for N by -1; r=r+1; _=_+ (@.r.c==wm);  if @.r.c=='' then ec=r c
           end   /*r*/
      if _==N | (_>=w & ec\=='')  then return 1
      return 0
