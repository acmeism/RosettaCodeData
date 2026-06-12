/*REXX pgm does a countdown and then display the launching of a rocket (ASCII animation)*/
parse arg cntDown .                              /*obtain optional argument from the CL.*/
if cntDown=='' | cntDown==","  then cntDown= 5   /*Not specified?  Then use the default.*/
  @. =                                           /* [↓]  glyphs for the rocket ship.    */
  @.1= '   /\   '
  @.2= '  |  |  '
  @.3= '  |  |  '
  @.4= '  |  |  '
  @.5= ' /|/\|\ '
  @.6= '/_||||_\'
                    do rs=1  while @.rs\==''     /*determine size of the rocket (height)*/
                    end   /*rs*/
rs= rs - 1                                       /*the true  rocket size  (height).     */
cls= 'CLS'                                       /*the command used to clear the screen.*/
parse value  scrsize()  with  sd sw .
sw= sw - 1                                       /*usable screen width on some systems. */
sd= sd - 3                                       /*   "      "   depth  "   "     "     */
air= sd - 1 - rs                                 /*"amount" of sky above the rocket.    */
say
      do j=cntDown  by -1  to 1                  /* [↓]  perform countdown; show rocket.*/
      cls                                        /*use this command to clear the screen.*/
      say  right(j, 9) 'seconds'                 /*display the amount of seconds to go. */
      call sky                                   /*display the sky above the rocket.    */
      call rocket                                /*display the rocket  (on the ground). */
      call delay 1                               /*wait one second during the countdown.*/
      end   /*j*/

say left('',9)       "liftoff!"                  /*announce liftoff of the rocket.      */
cls                                              /*use this command to clear the screen.*/
call sky                                         /*display the sky above the rocket.    */
period= 1
dt= period / sd                                  /*acceleration  (period is decreasing).*/
call rocket                                      /*display the rocket  (in flight).     */
             do  sd+4;      say                  /*"make" the rocket appear to fly.     */
             period= format(period-period*dt,,3) /*calculate the decrease in the period.*/
             call delay max(period, .001)        /*wait for a diminishing time interval.*/
             end   /*sd+4*/
exit                                             /*stick a fork in it, da rocket is gone*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
sky:     do air;   say;  end  /*air*/;   return  /*display the sky above the rocket.    */
rocket:  do ship=1  for rs;   say left('', sw%2 - 5)  @.ship;   end  /*ship*/;      return
