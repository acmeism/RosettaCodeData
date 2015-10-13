/*REXX pgm solves the holy knight's tour problem for a  NxN  chessboard.*/
blank=pos('//',space(arg(1),0))\==0    /*see if pennies are to be shown.*/
parse arg ops '/' cent                 /*obtain the options and pennies.*/
parse var ops N sRank sFile .          /*boardsize, starting pos, pennys*/
if     N=='' |     N==',' then     N=8 /*Boardsize specified?  Default. */
if sRank=='' | sRank==',' then sRank=N /*starting rank given?  Default. */
if sFile=='' | sFile==',' then sFile=1 /*    "    file   "        "     */
NN=N**2;  NxN='a ' N"x"N ' chessboard' /*[↓ ↓]      r f = Rank and File.*/
@.=;    do r=1  for N;  do f=1  for N;   @.r.f=.;   end /*f*/;   end /*r*/
                                       /*[↑]  blank the  NxN chessboard.*/
cent=space(translate(cent,,','))       /*allow use of comma (,) for sep.*/
cents=0                                /*number of pennies on chessboard*/
       do  while  cent\=''             /* [↓]  possibly place pennies.  */
       parse var cent cr cf x '/' cent /*extract where to place pennies.*/
       if x=''   then x=1              /*if # not specified, use 1 penny*/
       if cr=''  then iterate          /*support the "blanking" option. */
         do cf=cf  for x               /*now, place  X  pennies on board*/
         @.cr.cf='¢'                   /*mark board position with penny.*/
         end   /*cf*/                  /* [↑]  places X pennies on board*/
       end     /*while cent¬='' */     /* [↑]  allows of placing  X  ¢s.*/
                                       /* [↓]  traipse through the board*/
  do r=1  for N;  do f=1  for N;   cents=cents+(@.r.f=='¢');   end;   end
                                       /* [↑]  count number of pennies. */
if cents\==0  then say cents 'pennies placed on chessboard.'
target=NN-cents                        /*use this as the number of moves*/
                                       /*[↑]  create the NxN chessboard.*/
          Kr = '2 1 -1 -2 -2 -1  1  2' /*legal "rank" move for a knight.*/
          Kf = '1 2  2  1 -1 -2 -2 -1' /*  "   "file"   "   "  "    "   */
parse var Kr  Kr.1 Kr.2 Kr.3 Kr.4 Kr.5 Kr.6 Kr.7 Kr.8   /*parse by hand.*/
parse var Kf  Kf.1 Kf.2 Kf.3 Kf.4 Kf.5 Kf.6 Kf.7 Kf.8   /*  "    "   "  */
if @.sRank.sFile==.   then @.sRank.sFile=1      /*knight's starting pos.*/
if @.sRank.sFile\==1  then do   sRank=1  for N  /*find a starting rank.*/
                             do sFile=1  for N  /*  "  "    "     file.*/
                             if @.sRank.sFile\==.  then iterate
                             @.sRank.sFile=1
                             leave sRank        /*got a spot, so leave. */
                             end   /*sRank*/
                           end     /*sFile*/
if \move(2,sRank,sFile) &  \(N==1),
               then say "No holy knight's tour solution for"        NxN'.'
               else say "A solution for the holy knight's tour on"  NxN':'
                                       /*show chessboard with moves & ¢.*/
!=left('', 9*(n<18))                   /*used for indentation of board. */
_=substr(copies("┼───",N),2);   say;   say  ! translate('┌'_"┐", '┬', "┼")
     do   r=N  for N  by -1;           if r\==N  then say ! '├'_"┤";  L=@.
       do f=1  for N;     L=L'│'centre(@.r.f,3)   /*preserve squareness.*/
       end      /*f*/
     if blank then L=translate(L,,'¢') /*blank out the pennies ?        */
     say !  translate(L'│', , .)       /*show a  rank of the chessboard.*/
     end        /*r*/                  /*80 cols can view 19x19 chessbrd*/
say  !  translate('└'_"┘", '┴', "┼")   /*show the last rank of the board*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MOVE subroutine─────────────────────*/
move: procedure expose @. Kr. Kf. target;       parse arg #,rank,file
         do t=1  for 8;      nr=rank+Kr.t;      nf=file+Kf.t
         if @.nr.nf==.  then do;                @.nr.nf=#     /*Kn move.*/
                             if #==target       then return 1 /*last mv?*/
                             if move(#+1,nr,nf) then return 1
                             @.nr.nf=.          /*undo the above move.  */
                             end                /*try different move.   */
         end   /*t*/
return 0                                        /*the tour not possible.*/
