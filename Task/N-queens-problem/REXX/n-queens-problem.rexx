/*REXX program place N queens on a NxN chessboard (the 8 queens problem)*/
parse arg N .                          /*get board size arg  (if any).  */
if N==''  then N=8                     /*No argument?   Use the default.*/
file=1;   rank=1;               q=0    /*starting place,  #  of queens. */
@.=0;     !=left('', 9* (N<18))        /*define empty board, indentation*/
/*═════════════════════════════════════find solution:  N queens problem.*/
  do  while q<N                        /*keep placing queens until done.*/
  @.file.rank=1                        /*place a queen on the chessboard*/
  if safe?(file,rank) then do;   q=q+1 /*if not being attacked, eureka! */
                           file=1      /*another attempt at file #1,    */
                           rank=rank+1 /*and also bump the rank pointer.*/
                           end
                      else do          /*¬ safe, so it's a bad placement*/
                           @.file.rank=0      /* So, remove this queen. */
                           file=file+1        /*try the next file then. */

                             do  while file>N;           rank=rank-1
                             if rank==0  then call noSol
                               do j=1  for N
                               if @.j.rank then do; file=j;  @.file.rank=0
                                                q=q-1;       file=j+1
                                                leave  /*j*/
                                                end
                               end   /*j*/
                             end     /*do while file>N*/
                          end        /*else do*/
  end   /*while q<N*/
/*══════════════════════════════════════show chessboard with a solution.*/
say 'A solution for'  N  "queens:";    _ = substr( copies("┼───", N)  ,2)
lineT  = '┌'_"┐";                      say; say ! translate(lineT,'┬',"┼")
lineB  = '└'_"┘";                      lineB = translate(lineB, '┴', "┼")
line   = '├'_"┤"                       /*define a line for cell boundry.*/
bar    = '│'                           /*kinds: horizonal/vertical/salad*/
Bqueen = '░♀░'                         /*glyph befitting the black queen*/
Wqueen = ' ♀ '                         /*  "       "      "  white   "  */
/*═══════════════════════==══════════════place the queens on chessboard.*/
  do   r=1  for N;   if r\==1 then say ! line;  _=  /*process the rank &*/
    do f=1  for N;   black=(f+r)//2    /*the file; is it a black square?*/
    qgylph=Wqueen;   if black  then Qgylph=Bqueen   /*use a black queen.*/
           /*is it black sqare?*/

    if @.f.r then _=_ || bar || Qgylph /*use the 3-char symbol for queen*/
             else if black  then _=_ || bar'░░░'    /*¼ dithering char. */
                            else _=_ || bar'   '    /*three blanks.     */
    end   /*f*/                        /* [↑] preserve square chessboard*/
  say ! _ || bar
  end     /*r*/                        /*80 cols can view 19x19 chessbrd*/
say ! lineB;    say                    /*show last line, + a blank line.*/
exit  1                                /*stick a fork in it, we're done.*/
/*──────────────────────────────────NOSOL subroutine────────────────────*/
noSol:   say  "No solution for"   N   'queens.';             exit 0
/*──────────────────────────────────SAFE? subroutine────────────────────*/
safe?:  procedure expose @.;                     parse arg file,rank
                      do k=rank-1  to 1 by -1;   if @.file.k then return 0
                      end
f=file-1;  r=rank-1
                      do  while f\==0 & r\==0;   if @.f.r    then return 0
                      f=f-1;    r=r-1
                      end
f=file+1;  r=rank-1
                      do  while f<=n  & r\==0;   if @.f.r    then return 0
                      f=f+1;    r=r-1
                      end
return 1
