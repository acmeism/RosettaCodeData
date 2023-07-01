/*REXX pgm implements the 15─puzzle (AKA: Gem Puzzle, Boss Puzzle, Mystic Square, 14─15)*/
parse arg N seed .                               /*obtain optional arguments from the CL*/
if N=='' | N==","  then N=4                      /*Not specified?  Then use the default.*/
if datatype(seed, 'W')  then call random ,,seed  /*use repeatability seed for RANDOM BIF*/
nh= N**2;   @.=;    nn= nh - 1;    w= length(nn) /*define/initialize some handy values. */
$=                                               /*$: will hold the solution for testing*/
       do i=1  for nn;  $= $  i                  /* [◄]  build a solution for testing.  */
       end   /*i*/
done= $                                          /* [↓]  scramble the tiles in puzzle.  */
       do j=1  for nn;  a= random(1, words($) );    @.j= word($, a);   $= delword($, a, 1)
       end   /*j*/
                             /*═══════════════════ play the 15─puzzle 'til done or quit.*/
   do  until puzz==done & @.nh==''               /*perform moves until puzzle is solved.*/
   call getmv                                    /*get user's move(s)  and  validate it.*/
   if errMsg\==''  then do;  say sep errMsg;       iterate        /*possible error msg? */
                        end
   call showGrid 0                               /*don't display puzzle, just find hole.*/
   if wordpos(x, !)==0  then do;  say sep  'tile '     x     " can't be moved.";   iterate
                             end
   @.hole= x;    @.tile=
   call showGrid 0                               /*move specified tile ───► puzzle hole.*/
   end   /*until*/           /*═════════════════════════════════════════════════════════*/

call showGrid 1;    say;     say sep  'Congratulations!   The'      nn"-puzzle is solved."
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
getmv: x= 0;   sep= copies('─', 8);     pad= left('', 1 + length(sep) )   /*pad=9 blanks*/
       prompt= sep    'Please enter a tile number  or  numbers '     sep     " (or Quit)."
       if queued()==0  then do;    say;    call showGrid 1;     say;      say prompt
                            end
       parse pull x . 1 ox . 1 . zx;   upper x   /*obtain a number (or numbers) from CL.*/
       if abbrev('QUIT', x, 1)  then do;   say;   say;    say sep  "quitting.";      exit
                                     end
       if words(zx)>0  then do;  parse var  zx    xq;     queue xq
                            end                  /* [↑]  Extra moves?  Stack for later. */
              select                             /* [↓]  Check for possible errors/typos*/
              when x==''              then errMsg= "nothing entered."
              when \datatype(x, 'N')  then errMsg= "tile number isn't numeric: "        ox
              when \datatype(x, 'W')  then errMsg= "tile number isn't an integer: "     ox
              when x=0                then errMsg= "tile number can't be zero: "        ox
              when x<0                then errMsg= "tile number can't be negative: "    ox
              when x>nn               then errMsg= "tile number can't be greater than"  nn
              otherwise                    errMsg=
              end   /*select*/                   /* [↑]  verify the human entered data. */
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showGrid: parse arg show;       !.=;                      x= x/1;       #= 0;        puzz=
          top= '╔'copies( copies("═", w)'╦', N);        top= left( top, length(top) -1)"╗"
          bar= '╠'copies( copies("═", w)'╬', N);        bar= left( bar, length(bar) -1)"╣"
          bot= '╚'copies( copies("═", w)'╩', N);        bot= left( bot, length(bot) -1)"╝"
          if show  then say pad top

               do   r=1  for N;     z= '║'
                 do c=1  for N;     #= #+1;     y= @.#;      puzz= puzz y;        !.r.c= y
                 _= right(@.#, w)"║";           z= z || _              /* [↓]  find hole*/
                 if @.# == ''  then do;    hole= #;     holeRow= r;     holeCol= c;    end
                 if @.# == x   then do;    tile= #;     tileRow= r;     tileCol= c;    end
                 end   /*c*/                                           /* [↑]  find  X. */
               if show  then do;    say pad z;     if r\==N  then say pad bar;         end
               end     /*r*/

          rm=holeRow-1;   rp=holeRow+1;  cm=holeCol-1;  cp=holeCol+1   /*possible moves.*/
          !=!.rm.holeCol  !.rp.holeCol   !.holeRow.cm   !.holeRow.cp   /* legal   moves.*/
          if show  then say pad bot;                  return
