/*REXX program plays  "Snakes and Ladders"  game for any number of players (default 3). */
parse arg np seed .                              /*obtain optional arguments from the CL*/
if np=='' | np==","  then np= 3                  /*Not specified?  Then use the default.*/
if datatype(seed, 'W')  then call random ,,seed  /*maybe use a seed for the  RANDOM BIF.*/
pad= left('',7)                                  /*variable value used for indenting SAY*/
                    do k=1  for 100;    @.k= k   /*assign default values for board cells*/
                    end   /*k*/                  /* [↑]  number when landing on a square*/
                                                 /* [↓]  define ladder destinations.    */
@.4=14;  @.9=31;    @.20=38;  @.28=84;  @.40=59;   @.51=67;   @.63=81;   @.71=91;  @.95=75
@.17=7;  @.54=34;   @.62=19;  @.64=60;  @.87=24;   @.93=73;   @.99=78
                                                 /* [↑]  define snake  destinations.    */
player.= 1                                       /*start all players on the 1st square. */
          do games=1  until $==100;           say center(' turn '   games" ",  75,  "─")
              do j=1  for np  until $==100;   $= turn(j, player.j);            player.j= $
              end   /*j*/                        /*process each of the number of players*/
          end       /*games*/                    /*exit both loops when there's a winner*/
say pad  'Player '       j       " wins!"        /*announce the winner; the game is over*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
turn: parse arg P, square;     ?= random(1, 6)   /*simulate a roll of a six─sided die.  */
      @does= pad  'Player '    P    " on square "    right(square, 2)     ' rolls a '    ?
      if square+?>100  then do;  say @does   " but can't move.  Next player's turn."
                                 return square
                            end
                       else do;  square= square + ?                     /*move a player.*/
                                 say @does   " and moves to square"     right(square, 3)
                            end
      next= @.square                                                    /*where moved to*/
      @oops=   pad  pad  'Oops!  Landed on a snake,  slither down to'   right(next, 3)
      @ladder= pad  pad   'Yay!  Landed on a ladder,  climb up to'      right(next, 3)
      if square<next  then                       say right(@ladder, 69)
                      else  if square>next then  say right(@oops  , 69)
      return next
