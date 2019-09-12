/*REXX program  places   N   queens on an  NxN  chessboard  (the eight queens problem). */
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N= 8                     /*Not specified:  Then use the default.*/
if N<1  then call nOK                            /*display a message, the board is bad. */
rank= 1;    file= 1;       #=0                   /*starting rank&file;  #≡number queens.*/
@.= 0;      pad= left('', 9* (N<18) )            /*define empty board;  set indentation.*/
                                                 /* [↓]  rank&file ≡ chessboard row&cols*/
  do  while #<N;     @.file.rank= 1              /*keep placing queens until we're done.*/
  if ok(file, rank)  then do; file= 1;  #= # + 1 /*Queen not being attacked? Then eureka*/
                              rank= rank + 1     /*use another attempt at another rank. */
                              iterate            /*go and try another queen placement.  */
                          end                    /* [↑]  found a good queen placement.  */
  @.file.rank= 0                                 /*It isn't safe.  So remove this queen.*/
  file= file+1                                   /*So, try the next (higher) chess file.*/
               do  while file>N;    rank= rank - 1;            if rank==0  then call nOK
                  do j=1  for N;    if \@.j.rank  then iterate               /*¿ocupado?*/
                  @.j.rank= 0;      #= # - 1;          file= j + 1;        leave
                  end  /*j*/
               end     /*while file>N*/
  end                  /*while    #<N*/
call show
exit  1                                          /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
nOK: say;      say  "No solution for"      N      'queens.';          say;          exit 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
ok:  parse arg f,r;  fp= f + 1;   rm= r - 1      /*if return≡0,  then queen isn't safe. */
              do k=1          for rm;               if @.f.k  then return 0;           end
     f= f-1;  do k=rm  by -1  for rm  while f\==0;  if @.f.k  then return 0;  f= f-1;  end
     f= fp;   do k=rm  by -1  for rm  while f <=N;  if @.f.k  then return 0;  f= f+1;  end
     return 1   /*1≡queen is safe. */            /*  ↑↑↑↑↑↑↑↑    is queen under attack? */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: say  'A solution for '     N     " queens:"     /*display a title to the terminal.*/
      g= substr( copies("╬═══",  N)  ,2)              /*start of all cells on chessboard*/
      say;      say pad  translate('╔'g"╗", '╦', "╬") /*display top rank (of the board).*/
      line   = '╠'g"╣";   dither= "▓";   ditherQ= '░' /*define a line for cell boundary.*/
      bar    = '║'    ;   queen = "Q"                 /*kinds:   horiz.,  vert.,  salad.*/
      Bqueen = ditherQ || queen || ditherQ            /*glyph befitting a black square Q*/
      Wqueen =         ' 'queen" "                    /*  "       "     " white    "   "*/
        do   rank=1  for N;     if rank\==1  then say pad line;    _=  /*show rank sep. */
          do file=1  for N;         B = (file + rank)  //  2           /*square black ? */
          Qgylph= Wqueen;       if  B  then Qgylph= Bqueen             /*use dithered Q.*/
          if @.file.rank then _= _ || bar || Qgylph                    /*3─char Q symbol*/
                         else if B then _=_ || bar || copies(dither,3) /*dithering      */
                                   else _=_ || bar || copies(  ' ' ,3) /* 3 blanks      */
          end   /*file*/                              /* [↑]  preserve square─ish board.*/
        say pad  _ || bar                             /*show a single rank of the board.*/
        end     /*rank*/                              /*80 cols  can view a 19x19 board.*/
      say pad  translate('╚'g"╝", '╩', "╬");   return /*display the last rank (of board)*/
