/*REXX program solves the knight's tour  problem for a  NxN  chessboard.*/
parse arg  N  sRank sFile .            /*boardsize, starting position.  */
if     N=='' |     N==',' then     N=8 /*Boardsize specified?  Default. */
if sRank=='' | sRank==',' then sRank=N /*starting rank given?  Default. */
if sFile=='' | sFile==',' then sFile=1 /*    "    file   "        "     */
NN=N**2;  NxN='a ' N"x"N ' chessboard' /*[↓ ↓]      r f = Rank and File.*/
@.=;    do r=1  for N;  do f=1  for N;  @.r.f=.;  end  /*f*/;   end  /*r*/
                                       /*[↑]  create the NxN chessboard.*/
          Kr = '2 1 -1 -2 -2 -1  1  2' /*legal "rank" move for a knight.*/
          Kf = '1 2  2  1 -1 -2 -2 -1' /*  "   "file"   "   "  "    "   */
parse var Kr  Kr.1 Kr.2 Kr.3 Kr.4 Kr.5 Kr.6 Kr.7 Kr.8   /*parse by hand.*/
parse var Kf  Kf.1 Kf.2 Kf.3 Kf.4 Kf.5 Kf.6 Kf.7 Kf.8   /*  "    "   "  */
@.sRank.sFile=1                        /*the knight's starting position.*/
if \move(2,sRank,sFile)  &  \(N==1),   /* ◄═══ is there a NxN solution? */
                     then say "No knight's tour solution for"       NxN'.'
                     else say "A solution for the knight's tour on" NxN':'
                                       /* [↓]  display the chessboard.  */
!=left('', 9*(n<18))                   /*used for indentation of board. */
_=substr(copies("┼───",N),2);   say;   say  ! translate('┌'_"┐", '┬', "┼")
     do   r=N  for N  by -1;           if r\==N  then say ! '├'_"┤";  L=@.
       do f=1  for N;    L=L'│'centre(@.r.f, 3)   /*preserve squareness.*/
       end   /*f*/                     /*done with a rank on chessboard.*/
     say ! translate(L'│', , .)        /*show a  rank of the chessboard.*/
     end     /*r*/                     /*80 cols can view 19x19 chessbrd*/
say  !  translate('└'_"┘", '┴', "┼")   /*show the last rank of the board*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MOVE subroutine─────────────────────*/
move: procedure expose @. Kr. Kf. NN;           parse arg #,rank,file
         do t=1  for 8;      nr=rank+Kr.t;      nf=file+Kf.t  /*location*/
         if @.nr.nf==.  then do;                @.nr.nf=#     /*Kn move.*/
                             if #==NN           then return 1 /*last mv?*/
                             if move(#+1,nr,nf) then return 1 /*  "   " */
                             @.nr.nf=.          /*undo the above move.  */
                             end                /*try different move.   */
         end   /*t*/                            /* [↑]  all moves tried.*/
return 0                                        /*the tour not possible.*/
