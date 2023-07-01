/* REXX ***************************************************************
* 1) Build ordered Card deck
* 2) Create shuffled stack
* 3) Deal 5 cards to 4 players each
* 4) show what cards have been dealt and what's left on the stack
* 05.07.2012 Walter Pachl
**********************************************************************/
colors='S H C D'
ranks ='A 2 3 4 5 6 7 8 9 T J Q K'
i=0
cards=''
ss=''
Do c=1 To 4
  Do r=1 To 13
    i=i+1
    card.i=word(colors,c)word(ranks,r)
    cards=cards card.i
    End
  End
n=52                                   /* number of cards on deck    */
Do si=1 To 51                          /* pick 51 cards              */
  x=random(0,n-1)+1                    /* take card x (in 1...n)     */
  s.si=card.x                          /* card on shuffled stack     */
  ss=ss s.si                           /* string of shuffled stack   */
  card.x=card.n                        /* replace card taken         */
  n=n-1                                /* decrement nr of cards      */
  End
s.52=card.1                            /* pick the last card left    */
ss=ss s.52                             /* add it to the string       */
Say 'Ordered deck:'
Say '  'subword(cards,1,26)
Say '  'subword(cards,27,52)
Say 'Shuffled stack:'
Say '  'subword(ss,1,26)
Say '  'subword(ss,27,52)
si=52
deck.=''
Do ci=1 To 5                           /* 5 cards each               */
  Do pli=1 To 4                        /* 4 players                  */
    deck.pli.ci=s.si                   /* take top of shuffled deck  */
    si=si-1                            /* decrement number           */
    deck.pli=deck.pli deck.pli.ci      /* pli's cards as string      */
    End
  End
Do pli=1 To 4                          /* show the 4 dealt ...       */
  Say pli':' deck.pli
  End
Say 'Left on shuffled stack:'
Say '  'subword(ss,1,26)               /* and what's left on stack   */
Say '  'subword(ss,27,6)
