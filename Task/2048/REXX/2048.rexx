/*REXX program lets a user play the  2048  game on an  NxN  grid  (default is 4x4 grid).*/
parse arg N win seed .                           /*obtain optional arguments from the CL*/
if   N=='' |   N==","  then    N=     4          /*Not specified?  Then use the default.*/
if win=='' | win==","  then  win= 2**11          /* "      "         "   "   "      "   */
if datatype(seed, 'W') then call random ,,seed   /*Specified?  Then use seed for RANDOM.*/
L= length(win) + 2                               /*L:  used for displaying the grid #'s.*/
eye=copies("─", 8);  pad=left('', length(eye)+2) /*eye catchers; and perusable perusing.*/
b= ' '                                           /*comfortable readable name for a blank*/
@cls= 'CLS'                                      /*hardcoded command to clear the screen*/
prompt= eye "Please enter a direction  (Up, Down, Right, Left)       ───or───    Quit:"
move= 1;     moves= 0;      score= 0;      ok= 1 /*simulation that a move was performed.*/
@.= b                                            /*define all grid elements to a blank. */
     do  until any(win);  if ok  then call put;   ok= 1;   say;    call showGrid
     say;  say prompt;   parse pull a x . 1 d 2 1 way xx   /*show prompt; obtain answer.*/
     if datatype(a, 'U')     then @cls           /*if uppercase, then clear the screen. */
     if a==''  then do;  ok= 0                   /*the user entered blank(s) or nothing.*/
                         say copies(eye, 5)   'moves:'   moves    eye     "score:"   score
                         iterate                 /* [↑]  display # of moves & the score.*/
                    end
     upper d a x                                 /*uppercase contents of three variables*/
     if x\==''               then call err  "too many arguments entered: "   xx
     if abbrev('QUIT',a,1)   then do;  say;  say eye  "quitting the game".;  exit 1;   end
     good=abbrev('UP',a,1) | abbrev("DOWN",a,1) | abbrev('RIGHT',a,1) | abbrev("LEFT",a,1)
     if \good                then call err  "invalid direction: "       way
     if \ok  then  iterate;       moves= moves + 1;                call mov
     end   /*until*/
say
say translate(eye  "Congrats!!  You've won the"  win  'game!' eye,"═",'─')  "score:" score
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@:   procedure expose @.;  parse arg row,col;                return @.row.col
any: arg ?; do r=1  for N; do c=1  for N;  if @.r.c==?  then return 1; end; end;  return 0
err: say;   say eye  '***error*** '   arg(1);       say;                  ok=0;   return
o_c: $=;  do k=1  for N; $=$ word(@.k.c .,1); end;  !=space(translate($,,.))==''; return $
o_r: $=;  do k=1  for N; $=$ word(@.r.k .,1); end;  !=space(translate($,,.))==''; return $
put: if \any(b) then call err ,"game over, no more moves."; if move then call two; return
row: if r==0 | r>N  then return copies('═', L);                    return center(@.r.c, L)
ten: if random(9)==4  then return 4;   return 2  /*10% of the time,  use 4 instead of 2.*/
two:   do  until @.p.q==b;  p= random(1,N);  q= random(1,N);  end;   @.p.q= ten();  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showGrid:     do    r=0  for N+2;    _= '║';                 __= "╠"
                 do c=1  for N;      _= _  ||  row()'║';     __= __  ||  copies("═", L)'╬'
                 end   /*c*/
              if r==0  then _= '╔'translate( substr(_, 2, length(_) - 2),  "╦",  '║')"╗"
              if r >N  then _= '╚'translate( substr(_, 2, length(_) - 2),  "╩",  '║')"╝"
                                 say pad _
              if r<N & r>0  then say pad substr(__, 1, length(__) - 1)"╣"
              end      /*r*/;        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
mov: move= 0;    if d=='R'  then call moveLR N, 1, -1    /*move (slide) numbers    ►    */
                 if d=='L'  then call moveLR 1, N, +1    /*  "     "       "       ◄    */
                 if d=='U'  then call moveUD 1, N, +1    /*  "     "       "       ↑    */
                 if d=='D'  then call moveUD N, 1, -1    /*  "     "       "       ↓    */
     if \move  then call err 'moving '    way    " doesn't change anything.";       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
moveLR: parse arg start, sTo, #                                   /*slide   ◄   or   ►  */
          do   r=1  for N;    old= o_r();      if !  then iterate /*is this row blank?  */
            do N-1;           call packLR                         /*pack    ◄  or   ►   */
            end        /*N-1*/                                    /* [↓]  get new tiles.*/
          new= o_r();              move= move | (old\==new)       /*indicate tiles moved*/
              do c=start  for N-1  by #  while @.r.c\==b          /*slide   ◄  or   ►   */
              if @.r.c\==@(r,c+#)  then iterate                   /*not a duplicate ?   */
              @.r.c= @.r.c * 2;    score= score + @.r.c           /*double;  bump score */
              c= c + #        ;    @.r.c= b;         move= 1      /*bump C; blank dup 2.*/
              end      /*c*/                                      /* [↑]  indicate move.*/
          call packLR                                             /*pack    ◄  or    ►  */
          end          /*r*/;                        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
moveUD: parse arg start, Sto, #                                   /*slide   ↑   or   ↓  */
          do   c=1  for N;    old= o_c();      if !  then iterate /*is this col blank?  */
            do N-1;           call packUD                         /*pack  up or down.   */
            end        /*N-1*/                                    /* [↓]  get new tiles.*/
          new= o_c();              move= move | (old\==new)       /*indicate tiles moved*/
              do r=start  for N-1  by #  while @.r.c\==b          /*slide   ↑   or   ↓  */
              if @.r.c\==@(r+#,c)  then iterate                   /*not a duplicate ?   */
              @.r.c= @.r.c * 2;    score= score + @.r.c           /*double;  bump score */
              r= r + #        ;    @.r.c= b;         move= 1      /*bump R; blank dup 2.*/
              end      /*r*/                                      /* [↑]  indicate move.*/
          call packUD                                             /*pack    ↑   or   ↓  */
          end          /*c*/;                        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
packLR:   do c=start  for N-1  by #;   if @.r.c\==b  then iterate /*Not a blank?  Skip. */
             do s=c  to sTo  by #;     @.r.s= @(r, s + #)         /*slide   ◄   or   ►  */
             end   /*s*/;              @.r.sTo= b                 /*handle the last one.*/
          end      /*c*/;                            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
packUD:   do r=start  for N-1  by #;   if @.r.c\==b  then iterate /*Not a blank?  Skip. */
             do s=r  to sTo  by #;     @.s.c= @(s + #, c)         /*slide   ↑   or   ↓  */
             end   /*s*/;              @.sTo.c= b                 /*handle the last one.*/
          end      /*r*/;                            return
