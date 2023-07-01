/*REXX program analyzes an  N─card  poker hand,  and displays  what  the poker hand is. */
parse arg iFID .;       if iFID=='' | iFID==","  then iFID= 'POKERHAN.DAT'
                                                 /* [↓] read  the poker hands dealt.    */
      do  while lines(iFID)\==0;      ox= linein(iFID);       if ox=''  then iterate
      say right(ox, max(30, length(ox) ) )       ' ◄─── '       analyze(ox)
      end   /*while*/                            /* [↑]  analyze/validate the poker hand*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
analyze: procedure; arg x ';',mc;      hand= translate(x, '♥♦♣♠1', "HDCSA,");    flush= 0
kinds= 0;    suit.= 0;    pairs= 0;    @.= 0;         run= copies(0, 13);        pips= run
if mc==''  then mc= 5;    n= words(hand);  if n\==mc  then  return  'invalid'
                                                 /* [↓]  PIP can be  1 or 2  characters.*/
   do j=1  for n;      _= word(hand, j)          /*obtain a card from the dealt hand.   */
   pip= left(_, length(_) - 1);  ws= right(_, 1) /*obtain the card's pip;  and the suit.*/
   if pip==10  then pip= 'T'                     /*allow an alternate form for a "TEN". */
   @._= @._ + 1                                  /*bump the card counter for this hand. */
   #= pos(pip, 123456789TJQK)                    /*obtain the pip index for the card.   */
   if pos(ws, "♥♣♦♠")==0  then return 'invalid suit in card:'     _
   if #==0                then return 'invalid pip in card:'      _
   if @._\==1             then return 'invalid, duplicate card:'  _
   suit.ws= suit.ws + 1                          /*count the suits for a possible flush.*/
     flush= max(flush, suit.ws)                  /*count number of cards in the suits.  */
       run= overlay(., run, #)                   /*convert runs to a series of periods. */
         _= substr(pips, #, 1) + 1               /*obtain the number of the pip in hand.*/
      pips= overlay(_, pips, #)                  /*convert the pip to legitimate number.*/
     kinds= max(kinds, _)                        /*convert certain pips to their number.*/
   end   /*i*/                                   /* [↑]  keep track of  N─of─a─kind.    */

     run= run || left(run, 1)                    /*An  ace  can be  high  ─or─  low.    */
   pairs= countstr(2, pips)                      /*count number of pairs  (2s  in PIPS).*/
straight= pos(....., run || left(run, 1) ) \== 0 /*does the  RUN  contains a straight?  */
if flush==5 & straight  then return  'straight-flush'
if kinds==4             then return  'four-of-a-kind'
if kinds==3 & pairs==1  then return  'full-house'
if flush==5             then return  'flush'
if            straight  then return  'straight'
if kinds==3             then return  'three-of-a-kind'
if kinds==2 & pairs==2  then return  'two-pair'
if kinds==2             then return  'one-pair'
                             return  'high-card'
