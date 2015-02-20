/*REXX pgm solves the holy knight's tour problem for a  NxN  chessboard.*/
blank=pos('//',space(arg(1),0))\==0    /*see if pennies are to be shown.*/
parse arg ops '/' cent                 /*obtain the options and pennies.*/
parse var ops N sRank sFile .          /*boardsize, starting pos, pennys*/
if N=='' | N==','  then N=8            /*Boardsize specified?  Default. */
if sRank==''  then sRank=N             /*starting rank given?  Default. */
if sFile==''  then sFile=1             /*    "    file   "        "     */
NN=N**2;  NxN='a ' N"x"N ' chessboard' /* [↓]       r=Rank,      f=File.*/
@.=;    do r=1  for N;  do f=1  for N;   @.r.f=' '; end /*f*/;   end /*r*/
                                       /*[↑]  blank the  NxN chessboard.*/
cent=space(translate(cent,,','))       /*allow use of comma (,) for sep.*/
cents=0                                /*number of pennies on chessboard*/
       do  while  cent\=''             /* [↓]  possibly place pennies.  */
       parse var cent cr cf x '/' cent /*extract where to place pennies.*/
       if x=''   then x=1              /*if # not specified, use 1 penny*/
       if cr=''  then iterate          /*support the "blanking" option. */
         do cf=cf for x                /*now, place  X  pennies on board*/
         @.cr.cf='¢'                   /*mark board position with penny.*/
         end   /*cf*/                  /* [↑]  places X pennies on board*/
       end     /*while cent¬='' */     /* [↑]  allows of placing  X  ¢s.*/
                                       /* [↓]  traipse through the board*/
  do r=1  for N;  do f=1  for N;   cents=cents+(@.r.f=='¢');   end;   end
                                       /* [↑]  count number of pennies. */
if cents\==0  then say cents 'pennies placed on chessboard.'
target=NN-cents                        /*use this as the number of moves*/
Kr = '2 1 -1 -2 -2 -1  1  2'           /*legal "rank" move for a knight.*/
Kf = '1 2  2  1 -1 -2 -2 -1'           /*  "   "file"   "   "  "    "   */
                             do i=1  for words(Kr)  /*legal knight moves*/
                             Kr.i = word(Kr,i);     Kf.i = word(Kf,i)
                             end    /*i*/           /*for fast indexing.*/
!=left('', 9*(n<18))                   /*used for indentation of board. */
if @.sRank.sFile==' '   then @.sRank.sFile=1     /*knight's starting pos*/
if @.sRank.sFile\==1    then do sRank=1  for N   /*find a starting rank.*/
                             do sFile=1  for N   /*  "  "    "     file.*/
                             if @.sRank.sFile==' ' then do  /*got a spot*/
                                                        @.sRank.sFile=1
                                                        leave sRank
                                                        end
                             end   /*sRank*/
                           end     /*sFile*/
if \move(2,sRank,sFile) & ,
   \(N==1)  then say "No holy knight's tour solution for" NxN'.'
            else say "A solution for the holy knight's tour on" NxN':'
_=substr(copies("┼───",N),2);   say;   say  ! translate('┌'_"┐", '┬', "┼")
     do   r=N  for N  by -1;           if r\==N  then say ! '├'_"┤";  L=@.
       do f=1  for N;     L=L'│'centre(@.r.f,3)   /*preserve squareness.*/
       end      /*f*/
     if blank then L=translate(L,,'¢') /*blank out the pennies ?        */
     say ! L'│'                        /*show a  rank of the chessboard.*/
     end        /*r*/                  /*80 cols can view 19x19 chessbrd*/
say  !  translate('└'_"┘", '┴', "┼")   /*show the last rank of the board*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MOVE subroutine─────────────────────*/
move: procedure expose @. Kr. Kf. N target;  parse arg #,rank,file;  b=' '
         do t=1  for 8;      nr=rank+Kr.t;      nf=file+Kf.t
         if @.nr.nf==b  then do;                @.nr.nf=#     /*Kn move.*/
                             if #==target       then return 1 /*last mv?*/
                             if move(#+1,nr,nf) then return 1
                             @.nr.nf=b          /*undo the above move.  */
                             end                /*try different move.   */
         end   /*t*/
return 0                                        /*the tour not possible.*/
