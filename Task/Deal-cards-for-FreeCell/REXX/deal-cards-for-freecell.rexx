/*REXX program deals cards for a specific  FreeCell solitaire  card game  (0 ──► 32767).*/
numeric digits 15                                /*ensure enough digits for the random #*/
parse arg g c .                                  /*obtain optional arguments from the CL*/
if g=='' | g==","  then g=1                      /*No game specified?  Then use default.*/
if c=='' | c==","  then c=8                      /* " cols     "         "   "     "    */
state=g                                          /*seed random # generator with game num*/
if 8=='f8'x  then suit= "cdhs"                   /*EBCDIC?   Then use letters for suits.*/
             else suit= "♣♦♥♠"                   /* ASCII?     "   "  symbols  "    "   */
rank= 'A23456789tJQK'                            /*t  in the rank represents a ten (10).*/
__=left('', 13)                                  /*used for indentation for the tableau.*/
say center('tableau for FreeCell game' g,50,"─") /*show a title for the FreeCell game #.*/
say                                              /* [↓]  @  is an array of all 52 cards.*/
#=-1;  do   r=1  for length(rank)                /*build the deck  first   by the rank. */
         do s=1  for length(suit);       #=#+1   /*  "    "    "  secondly  "  "  suit. */
         @.#=substr(rank,r,1)substr(suit,s,1)    /*build the $ array one card at at time*/
         end   /*s*/                             /* [↑]  first card is number  0 (zero).*/
       end     /*r*/                             /* [↑]  build deck per FreeCell rules. */
$=__                                             /*@: cards to be dealt, eight at a time*/
       do cards=51  by -1  for 52                /* [↓]  deal the cards for the tableau.*/
       ?=rand() // (cards+1)                     /*get next rand#;  card # is remainder.*/
       $=$ @.?;                 @.?=@.cards      /*swap two cards:  use random and last.*/
       if words($)==c  then do; say $; $=__; end /*deal FreeCell cards for the tableau. */
       end   /*cards*/                           /*normally, 8 cards are dealt to a row.*/
                                                 /* [↓]  residual cards may exist.      */
if $\=''  then say $                             /*Any residual cards in the tableau ?  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
rand:  state=(214013*state + 2531011) // 2**31;  return state % 2**16   /*FreeCell rand#*/
