/*REXX program  places   N   queens on an  NxN  chessboard  (the eight queens problem). */
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N=8                      /*Not specified:  Then use the default.*/
if N<1  then call noSol                          /*display a message, the board is bad. */
rank=1;   file=1;       #=0                      /*starting rank&file;  #≡number queens.*/
@.=0;     pad=left('', 9* (N<18))                /*define empty board;  set indentation.*/

  do  while #<N;       @.file.rank=1             /*keep placing queens until we're done.*/
  if ok(file,rank)  then do;   #=#+1             /*Queen not being attacked? Then eureka*/
                         file=1                  /*use another attempt at another file. */
                         rank=rank+1             /*and also bump the rank counter.      */
                         iterate                 /*go and try another queen placement.  */
                         end                     /* [↑]  found a good queen placement.  */
  @.file.rank=0                                  /*It isn't safe.  So remove this queen.*/
  file=file+1                                    /*So, try the next (higher) file.      */
              do  while file>N;   rank=rank-1;       if rank==0  then call noSol
                do j=1  for N;    if \@.j.rank  then iterate                 /*occupied?*/
                file=j;  @.file.rank=0;   #=#-1;     file=j+1;   leave /*j*/
                end  /*j*/
              end    /*while file>N*/
  end                /*while    #<N*/

say 'A solution for'  N  "queens:";    a = substr( copies("┼───",  N)  ,2);  say
say pad  translate('┌'a"┐", '┬', "┼")            /*display the top rank  (of the board).*/
line   = '├'a"┤";     dither='░'                 /*define a line (bar) for cell boundry.*/
bar    = '│'    ;     queen='Q'                  /*kinds:  horizontal, vertical, salad. */
Bqueen = dither || queen || dither               /*glyph befitting a black-square queen.*/
Wqueen =        ' 'queen" "                      /*  "       "     " white-square   "   */

  do   rank=1  for N;   if rank\==1  then say pad line;  _=      /*display sep for rank.*/
    do file=1  for N;   B=(file+rank)//2                         /*is the square black? */
    Qgylph=Wqueen;      if B then Qgylph=Bqueen                  /*use a dithered queen.*/
    if @.file.rank then _=_ || bar || Qgylph                     /*3-char queen symbol. */
                   else if B then _=_ || bar || copies(dither,3) /*use dithering for sq.*/
                             else _=_ || bar || copies(' '   ,3) /* "   3 blanks  "   " */
    end   /*file*/                               /* [↑]  preserve square-ish chessboard.*/
  say pad  _ || bar                              /*show a single rank of the chessboard.*/
  end     /*rank*/                               /*80 cols  can view a 19x19 chessboard.*/

say pad  translate('└'a"┘", '┴', "┼")            /*display the last rank (of the board).*/
exit  1                                          /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
noSol:  say;   say  "No solution for"   N   'queens.';      say;      exit 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
ok:     parse arg f,r;              rm=r-1;            fm=f-1;                  fp=f+1
                do k=1          for rm;                if @.f.k  then return 0;        end
          f=fm; do k=rm  by -1  for rm  while f\==0;   if @.f.k  then return 0; f=f-1; end
          f=fp; do k=rm  by -1  for rm  while f <=N;   if @.f.k  then return 0; f=f+1; end
        return 1                                 /*    ↑↑↑↑↑↑↑↑   is queen under attack?*/
