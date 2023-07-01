/*REXX pgm simulates scenarios for a two─bullet Russian roulette game with a 6 cyl. gun.*/
parse arg cyls tests seed .                      /*obtain optional arguments from the CL*/
if  cyls=='' |  cyls==","  then  cyls=      6    /*Not specified?  Then use the default.*/
if tests=='' | tests==","  then tests= 100000    /* "      "         "   "   "     "    */
if datatype(seed, 'W')  then call random ,,seed  /* "      "         "   "   "     "    */
cyls_ = cyls - 1;          @0= copies(0, cyls)   /*shortcut placeholder for cylinders-1 */
@abc= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'               /*indices for the various options used.*/
scenarios= 'LSLSFsF  LSLSFF  LLSFSF  LLSFF'      /*the list of scenarios to be tested.  */
#= words(scenarios)                              /*the number of actions in a scenario. */
                                                 /*The scenarios are case insensitive.  */
        do m=1  for #;     q= word(scenarios, m) /*test each of the scenarios specified.*/
                           sum= 0                /*initialize the  sum  to zero.        */
           do tests;       sum= sum + method()   /*added the sums up for the percentages*/
           end   /*tests*/
                                    pc= left( (sum * 100 / tests)"%",  7)
        say act()   '  (option'     substr(@abc, m, 1)")   produces  "    pc    ' deaths.'
        end   /*m*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fire:   != left(@, 1);      @= right(@, cyls_)left(@, 1);   /* ◄──── next cyl.*/  return !
load:   if left(@, 1)  then @= right(@, cyls_)left(@, 1);  @= 1||right(@, cyls_); return
spin:   ?= random(1, cyls);    if ?\==cyls  then @= substr(@ || @, ? + 1, cyls);  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
method: @= @0;   do a=1  for length(q);          y= substr(q, a, 1)
                 if y=='L'  then call load
                            else if y=='S'  then call spin
                                            else if y=='F'  then if fire()  then return 1
                 end   /*a*/;                                                    return 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
act:    $=;      do a=1  for length(q);          y= substr(q, a, 1)
                 if y=='L'  then $= $", load"
                 if y=='S'  then $= $", spin"
                 if y=='F'  then $= $", fire"
                 end   /*a*/;                  return right( strip( strip($, , ",") ), 45)
