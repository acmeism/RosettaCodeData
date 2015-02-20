/*REXX pgm generates a random starting position for the  Chess960  game.*/
parse arg seed .                       /*allow for (RAND) repeatability.*/
if seed\==''  then call random ,,seed  /*if SEED specified, use the seed*/
@.=.                                   /*define the (empty) first rank. */
r1=random(1,8)                         /*generate the first rook, rank 1*/
@.r1='R'                               /*place the  first rook on rank1.*/
          do  until  r2\==r1  &  r2\==r1-1  &  r2\==r1+1
          r2=random(1,8)               /*find placement for the 2nd rook*/
          end   /*forever*/
@.r2='r'                               /*place the second rook on rank 1*/
_=random(min(r1, r2)+1, max(r1, r2)-1) /*find a random possition of king*/
@._='K'                                /*place king between the 2 rooks.*/
          do _=0      ; b1=random(1,8);  if @.b1\==. then iterate; c=b1//2
            do forever; b2=random(1,8) /* c=color of bishop ►──────┘    */
            if @.b2\==. | b2==b1 | b2//2==c  then iterate /*bad position*/
            leave _                    /*found position for the 2 clergy*/
            end   /*forever*/          /* [↑]  find a place: 1st bishop.*/
          end     /* _ */              /* [↑]    "  "   "    2nd    "   */
@.b1='B'                               /*place the  1st  bishop on rank1*/
@.b2='b'                               /*  "    "   2nd     "    "   "  */
                                       /*place the two knights on rank 1*/
   do  until @._='N'; _=random(1,8); if @._\==. then iterate; @._='N'; end
   do  until @.!='n'; !=random(1,8); if @.!\==. then iterate; @.!='n'; end
_=                                     /*only the queen is left to place*/
   do i=1  for 8;  _=_ || @.i;   end   /*construct output:  first rank. */
say translate(translate(_, 'q', .))    /*stick a fork in it, we're done.*/
