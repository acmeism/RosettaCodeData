/*REXX pgm deals cards for a specific FreeCell solitaire card game (0──►32767)*/
numeric digits 15                      /*ensure enough digits for the random #*/
parse arg g .;  if g==''  then g=1     /*if game isn't specified, use default.*/
state=g                                /*seed the random # generator with game*/
if 8=='f8'x  then suit='cdhs'          /*EBCDIC?   Then use letters for suits.*/
             else suit='♣♦♥♠'          /* ASCII?     "   "  symbols  "    "   */
rank='A23456789TJQK'                   /*T  in the rank represents a ten (10).*/
__=left('', 13)                        /*used for indentation for the tableau.*/
say center('tableau for FreeCell game' g,50,'─');  say  /*show title for game#*/
#=-1                                   /*$  is an array of all the  52  cards.*/
     do   r=1  for length(rank)                /*build deck first by the rank.*/
       do s=1  for length(suit);  #=#+1        /*  "     "  secondly by suit. */
       $.#=substr(rank,r,1)substr(suit,s,1)    /*build array 1 card at at time*/
       end   /*s*/                             /* [↑]  first card is number 0.*/
     end     /*r*/                     /* [↑]  build deck per FreeCell rules. */
@=__                                   /*@: cards to be dealt, eight at a time*/
     do cards=51  by -1  for 52        /* [↓]  deal the cards for the tableau.*/
     ?=rand() // (cards+1)             /*get next rand#;  card # is remainder.*/
     @=@ $.?;  $.?=$.cards                       /*swap 2 cards: random & last*/
     if words(@)==8  then do; say @;  @=__; end  /*deal cards for the tableau.*/
     end   /*cards*/                             /*8 cards are dealt to a row.*/
                                                 /* [↓]  residual cards exist.*/
              if @\==''  then say @              /*residual cards for tableau.*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────RAND subroutine───────────────────────────*/
rand: state = (214013 * state  +  2531011) // 2**31;        return state % 2**16
