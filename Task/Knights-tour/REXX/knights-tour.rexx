/*REXX program solves the  knight's tour  problem   for a  (general)   NxN   chessboard.*/
parse arg  N  sRank sFile .                      /*obtain optional arguments from the CL*/
if     N=='' |     N==","  then     N=8          /*No boardsize specified?  Use default.*/
if sRank=='' | sRank==","  then sRank=N          /*No starting rank given?   "      "   */
if sFile=='' | sFile==","  then sFile=1          /* "     "    file   "      "      "   */
NN=N**2;  NxN='a ' N"x"N ' chessboard'           /*file [↓]           [↓]   r=rank      */
@.=;    do r=1  for N;  do f=1  for N;  @.r.f=.;  end  /*f*/;   end  /*r*/
beg='-1-'                                        /*[↑]  create an empty  NxN chessboard.*/
          Kr = '2 1 -1 -2 -2 -1  1  2'           /*the legal "rank"  moves for a knight.*/
          Kf = '1 2  2  1 -1 -2 -2 -1'           /* "    "   "file"    "    "  "    "   */
parse var Kr  Kr.1 Kr.2 Kr.3 Kr.4 Kr.5 Kr.6 Kr.7 Kr.8   /*parse the legal moves by hand.*/
parse var Kf  Kf.1 Kf.2 Kf.3 Kf.4 Kf.5 Kf.6 Kf.7 Kf.8   /*  "    "    "     "    "   "  */
@.sRank.sFile= beg                               /*the knight's starting position.      */
@kt= "knight's tour"                             /*a handy-dandy literal for the  SAYs. */
if \move(2,sRank,sFile)  &  \(N==1)  then say 'No'  @kt  "solution for"        NxN'.'
                                     else say 'A solution for the'  @kt  "on"  NxN':'
!=left('', 9*(n<18))                             /*used for indentation of chessboard.  */
_=substr(copies("┼───",N),2);   say;   say  ! translate('┌'_"┐", '┬', "┼")    /*a square*/
                                                 /* [↓]  build a display for chessboard.*/
     do   r=N  for N  by -1;    if r\==N  then say ! '├'_"┤";  L=@.
       do f=1  for N; ?=@.r.f;  if ?==NN  then ?='end';  L=L'│'center(?,3)  /*is "end"? */
       end   /*f*/                               /*done with   rank   of the chessboard.*/
     say ! translate(L'│', , .)                  /*display a     "     "  "       "     */
     end     /*r*/                               /*19x19 chessboard can be shown 80 cols*/

say  !  translate('└'_"┘", '┴', "┼")             /*show the last rank of the chessboard.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
move: procedure expose @. Kr. Kf. NN;  parse arg #,rank,file    /*obtain move,rank,file.*/
         do t=1  for 8;      nr=rank+Kr.t;       nf=file+Kf.t   /*position of the knight*/
         if @.nr.nf==.  then do;                 @.nr.nf=#      /*Empty? Knight can move*/
                             if #==NN            then return 1  /*is this the last move?*/
                             if move(#+1,nr,nf)  then return 1  /* "   "   "    "    "  */
                             @.nr.nf=.                          /*undo the above move.  */
                             end                                /*try different move.   */
         end   /*t*/                                            /* [↑]  all moves tried.*/
return 0                                                        /*tour is not possible. */
