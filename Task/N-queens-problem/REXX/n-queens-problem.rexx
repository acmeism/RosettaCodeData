/*REXX program places N queens on a NxN chessboard; the 8 queens problem*/
parse arg N .                          /*get board size arg  (if any).  */
if N==''  then N=8; if N<1 then call noSol   /*No arg?  Use the default.*/
rank=1;   file=1;   q=0                /*starting rank & file; # queens.*/
@.=0;     !=left('', 9* (N<18))        /*define empty board, indentation*/
/*═════════════════════════════════════find solution:  N queens problem.*/
  do  while q<N;      @.file.rank=1    /*keep placing queens until done.*/
  if safe?(file,rank) then do;   q=q+1 /*if not being attacked, eureka! */
                           file=1      /*another attempt at another file*/
                           rank=rank+1 /*and also bump the rank pointer.*/
                           iterate     /*go&try another queen placement.*/
                           end         /* [↑]  found a good Q placement.*/
  @.file.rank=0                        /*not safe, so remove this queen.*/
  file=file+1                          /*So, try the next (higher) file.*/
              do  while file>N;  rank=rank-1;  if rank==0  then call noSol
                do j=1  for N;   if \@.j.rank  then iterate  /*occupied?*/
                file=j;  @.file.rank=0;  q=q-1;   file=j+1;   leave  /*j*/
                end  /*j*/
              end    /*while file>N*/
  end                /*while q<N*/
/*══════════════════════════════════════show chessboard with a solution.*/
say 'A solution for'  N  "queens:";    _ = substr( copies("┼───",  N)  ,2)
lineT  = '┌'_"┐";                      say; say ! translate(lineT,'┬',"┼")
lineB  = '└'_"┘";                      lineB = translate(lineB, '┴', "┼")
line   = '├'_"┤"                       /*define a line for cell boundry.*/
bar    = '│'                           /*kinds: horizonal/vertical/salad*/
if 1=='f1'x  then do; queenSymbol='Q'; dither='9c'x; end   /*for EBCDIC.*/
             else do; queenSymbol='♀'; dither='b0'x; end   /* "   ASCII.*/
Bqueen = dither||queenSymbol||dither   /*glyph befitting the black queen*/
Wqueen = ' 'queenSymbol" "             /*  "       "      "  white   "  */
/*═══════════════════════════════════════show chessboard with the queens*/
  do   r=1  for N;   if r\==1  then say ! line;  _= /*process the rank &*/
    do f=1  for N;   black=(f+r)//2    /*the file; is it a black square?*/
    Qgylph=Wqueen;   if black  then Qgylph=Bqueen   /*use a black queen.*/
           /*is it black sqare?*/
    if @.f.r then _=_ || bar || Qgylph /*use the 3-char symbol for queen*/
             else if black  then _=_||bar||copies(dither,3) /*dithering.*/
                            else _=_||bar'   '              /*3 blanks. */
    end   /*f*/                        /* [↑] preserve square chessboard*/
  say ! _ || bar                       /*show a rank of the chessboard. */
  end     /*r*/                        /*80 cols can view 19x19 chessbrd*/
say ! lineB;    say                    /*show last line, + a blank line.*/
exit  1                                /*stick a fork in it, we're done.*/
/*──────────────────────────────────NOSOL subroutine────────────────────*/
noSol:   say  "No solution for"   N   'queens.';             exit 0
/*──────────────────────────────────SAFE? subroutine────────────────────*/
safe?: procedure expose @. N;  parse arg f,r;   rm=r-1;   fm=f-1;   fp=f+1
      do k=1        for rm;             if @.f.k then return 0;        end
f=fm; do k=rm by -1 for rm while f\==0; if @.f.k then return 0; f=f-1; end
f=fp; do k=rm by -1 for rm while f <=N; if @.f.k then return 0; f=f+1; end
return 1
