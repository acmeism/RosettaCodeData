/*REXX program to simulate the problem of 100 prisoners:  random,  and optimal strategy.*/
parse arg men trials seed .                      /*obtain optional arguments from the CL*/
if    men=='' |    men==","  then    men=    100 /*number of   prisoners   for this run.*/
if trials=='' | trials==","  then trials= 100000 /*  "     "  simulations   "    "   "  */
if datatype(seed, 'W')  then call random ,,seed  /*seed for the random number generator.*/
try= men % 2;                swaps= men * 3      /*number tries for searching for a card*/
$.1= ' a simple ';           $.2= "an optimal"   /*literals used for the SAY instruction*/
say center(' running'  commas(trials)   "trials with"  commas(men)  'prisoners ', 70, "═")
say
    do strategy=1  for 2;    pardons= 0          /*perform the two types of strategies. */

      do trials;             call gCards         /*do trials for a strategy;  gen cards.*/
        do p=1  for men  until failure           /*have each prisoner go through process*/
        if strategy==1  then failure= simple()   /*Is 1st strategy?  Use simple strategy*/
                        else failure= picker()   /* " 2nd     "       "  optimal   "    */
        end   /*p*/                              /*FAILURE ≡ 1?  Then a prisoner failed.*/
      if #==men  then pardons= pardons + 1       /*was there a pardon of all prisoners? */
      end     /*trials*/                         /*if 1 prisoner fails, then they all do*/

    pc= format( pardons/trials*100, , 3);                           _= left('', pc<10)
    say right('Using', 9)  $.strategy  "strategy yields pardons "   _||pc"%  of the time."
    end       /*strategy*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _;  do c=length(_)-3  to 1  by -3; _= insert(',', _, c); end;  return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
gCards: #= 0;                do j=1  for men;  @.j= j             /*define seq. of cards*/
                             end   /*j*/                          /*same as seq. of men.*/
               do swaps;             a= random(1, men)            /*get 1st rand number.*/
                   do until  b\==a;  b= random(1, men)            /* "  2nd   "     "   */
                   end   /*until*/                                /* [↑] ensure A ¬== B */
               parse value  @.a @.b  with  @.b @.a                /*swap 2 random cards.*/
               end       /*swaps*/;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
simple: !.= 0; do try;         do until !.?==0; ?= random(1, men) /*get random card ··· */
                               end   /*until*/                    /*··· not used before.*/
               if @.?==p  then do;   #= #+1;  return 0;  end      /*found his own card? */
               !.?= 1                                             /*flag as being used. */
               end   /*try*/;        return 1                     /*didn't find his card*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
picker: ?= p;  do try; if @.?==p  then do;   #= #+1;    return 0  /*Found his own card? */
                                       end       /* [↑]  indicate success for prisoner. */
               ?= @.?                            /*choose next drawer from current card.*/
               end   /*try*/;        return 1    /*choose half of the number of drawers.*/
