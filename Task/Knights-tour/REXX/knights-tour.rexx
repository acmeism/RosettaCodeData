/*REXX pgm to solve the  knight's tour  problem for a  NxN  chessboard. */
parse arg N .; if N=='' | N==',' then N=8 /*user can specify board size.*/
NoNo= "No knight's tour solution for" NxN'.';           @.=
              /*define the outside of the board*/
NN=N**2;  NxN='a ' N"x"N ' chessboard' /* [↓]  R=rank,  F=file.         */
  do r=1  for N;    do f=1  for N;    @.r.f=0;   end  /*f*/;    end  /*r*/
                                       /*[↑] zero out the NxN chessboard*/
Kr = '2 1 -1 -2 -2 -1  1  2'           /*legal "rank" move for a knight.*/
Kf = '1 2  2  1 -1 -2 -2 -1'           /*  "   "file"   "   "  "    "   */
                                 do i=1  for 8      /*legal knight moves*/
                                 Kr.i = word(Kr,i);      Kf.i = word(Kf,i)
                                 end   /*i*/        /*for fast indexing.*/
@.1.1 = 1                              /*the knight's starting position.*/
if \(N==1) & \move(2,1,1)  then  do;   say NoNo;   exit;    end
say "A solution for the knight's tour on" NxN':';!=left('',9*(n<18))
_=substr(copies("┼───",N),2);   say;   say  ! translate('┌'_"┐", '┬', "┼")
     do   r=N  for N  by -1;           if r\==N  then say ! '├'_"┤";  L=@.
       do f=1  for N;     L=L'│'centre(@.r.f,3)   /*preserve squareness.*/
       end      /*f*/
     say ! L'│'                        /*show a rank of the chessboard. */
     end        /*r*/                  /*80 cols can view 19x19 chessbrd*/
say ! translate('└'_"┘", '┴', "┼")     /*show the last rank of the board*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MOVE subroutine─────────────────────*/
move: procedure expose @. Kr. Kf. N NN;   parse arg #,rank,file
           do t=1  for 8;     nr=rank+Kr.t;      nf=file+Kf.t
           if @.nr.nf==0 then do;                @.nr.nf=#     /*Kn move*/
                              if #==NN           then return 1 /*last 1?*/
                              if move(#+1,nr,nf) then return 1
                              @.nr.nf=0          /*undo the above move. */
                              end
           end   /*t*/
return 0
