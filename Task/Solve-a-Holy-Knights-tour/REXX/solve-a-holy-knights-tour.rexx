/*REXX program solves the  holy knight's tour  problem for a (general)  NxN  chessboard.*/
blank=pos('//', space(arg(1), 0))\==0            /*see if the pennies are to be shown.  */
parse arg  ops   '/'   cent                      /*obtain the options and the pennies.  */
parse var  ops  N  sRank  sFile .                /*boardsize, starting position, pennys*/
if     N=='' |     N==","  then     N=8          /*no boardsize specified?  Use default.*/
if sRank=='' | sRank==","  then sRank=N          /*starting rank given?      "      "   */
if sFile=='' | sFile==","  then sFile=1          /*    "    file   "         "      "   */
NN=N**2;  NxN='a ' N"x"N ' chessboard'           /*file  [↓]          [↓]   r=rank      */
@.=;    do r=1  for N;  do f=1  for N;   @.r.f=.;   end /*f*/;   end /*r*/
                                                 /*[↑]  create an empty  NxN chessboard.*/
cent=space(translate(cent, , ','))               /*allow use of comma (,) for separater.*/
cents=0                                          /*number of pennies on the chessboard. */
       do  while  cent\=''                       /* [↓]  possibly place the pennies.    */
       parse var  cent   cr  cf  x  '/'  cent    /*extract where to place the pennies.  */
       if x=''   then x=1                        /*if number not specified, use 1 penny.*/
       if cr=''  then iterate                    /*support the  "blanking"  option.     */
         do cf=cf  for x                         /*now, place  X  pennies on chessboard.*/
         @.cr.cf='¢'                             /*mark chessboard position with a penny*/
         end   /*cf*/                            /* [↑]  places X pennies on chessboard.*/
       end     /*while*/                         /* [↑]  allows of the placing of  X  ¢s*/
                                                 /* [↓]  traipse through the chessboard.*/
  do r=1  for N;  do f=1  for N;   cents=cents+(@.r.f=='¢');   end;   end
                                                 /* [↑]  count the number of pennies.   */
if cents\==0  then say cents 'pennies placed on chessboard.'
target=NN-cents                                  /*use this as the number of moves left.*/
beg='-1-'                                        /*[↑]  create the  NxN  chessboard.    */
          Kr = '2 1 -1 -2 -2 -1  1  2'           /*the legal "rank"  moves for a knight.*/
          Kf = '1 2  2  1 -1 -2 -2 -1'           /* "    "   "file"    "    "  "    "   */
parse var Kr  Kr.1 Kr.2 Kr.3 Kr.4 Kr.5 Kr.6 Kr.7 Kr.8   /*parse the legal moves by hand.*/
parse var Kf  Kf.1 Kf.2 Kf.3 Kf.4 Kf.5 Kf.6 Kf.7 Kf.8   /*  "    "    "     "    "   "  */
if @.sRank.sFile==.   then @.sRank.sFile=beg     /*the knight's starting position.      */

if @.sRank.sFile\==beg  then do    sRank=1  for N   /*find starting rank for the knight.*/
                                do sFile=1  for N   /*  "     "     file  "   "     "   */
                                if @.sRank.sFile\==.  then iterate
                                @.sRank.sFile=beg   /*the knight's starting position.   */
                                leave sRank         /*we have a spot, so leave all this.*/
                                end   /*sRank*/
                             end      /*sFile*/
@hkt= "holy knight's tour"                       /*a handy-dandy literal for the  SAYs. */
if \move(2,sRank,sFile)  &  \(N==1)  then say 'No'   @hkt   "solution for"       NxN'.'
                                     else say 'A solution for the'  @hkt  "on"   NxN':'

                                                 /*show chessboard with moves & pennies.*/
!=left('', 9*(n<18))                             /*used for indentation of chessboard.  */
_=substr(copies("┼───",N),2);   say;   say  ! translate('┌'_"┐", '┬', "┼")
     do   r=N  for N  by -1;    if r\==N  then say ! '├'_"┤";  L=@.
       do f=1  for N; ?=@.r.f;  if ?==target  then ?='end';  L=L'│'center(?,3)  /*"end"?*/
       end      /*f*/
     if blank then L=translate(L,,'¢')           /*blank out the pennies on chessboard ?*/
     say !  translate(L'│', , .)                 /*display  a  rank of the  chessboard. */
     end        /*r*/                            /*19x19 chessboard can be shown 80 cols*/
say  !  translate('└'_"┘", '┴', "┼")             /*display the last rank of chessboard. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
move: procedure expose @. Kr. Kf. target; parse arg #,rank,file /*obtain move,rank,file.*/
         do t=1  for 8;      nr=rank+Kr.t;       nf=file+Kf.t   /*position of the knight*/
         if @.nr.nf==.  then do;                 @.nr.nf=#      /*Empty? Knight can move*/
                             if #==target        then return 1  /*is this the last move?*/
                             if move(#+1,nr,nf)  then return 1  /* "   "   "    "    "  */
                             @.nr.nf=.                          /*undo the above move.  */
                             end                                /*try different move.   */
         end   /*t*/                                            /* [↑]  all moves tried.*/
return 0                                                        /*tour is not possible. */
