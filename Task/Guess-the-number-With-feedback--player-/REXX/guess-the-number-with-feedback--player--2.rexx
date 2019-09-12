/*REXX program plays  guess─the─number  (with itself)  with  positive rational numbers. */
parse arg low high frac seed .                   /*obtain optional arguments from the CL*/
if  low=='' |  low=="," then  low=    1          /*Not specified?  Then use the default.*/
if high=='' | high=="," then high= 1000          /* "      "         "   "   "     "    */
if frac=='' | frac=="," then frac=    1          /* "      "         "   "   "     "    */
if datatype(seed, 'W')  then call random ,,seed  /*Useful seed?  Then use a random seed.*/
fdigs= 10**frac                                  /*compute the number of fractional digs*/
?= random(low, high) + random(0,fdigs) / fdigs   /*Tougher game?  It may have fractions.*/
$= "──────── Try to guess my number  (it's between  "        /*part of a prompt message.*/
g=                                                           /*nullify the first guess. */
    do #=1;                        oldg= g       /*save the guess for later comparison. */
    if pos('high', info)\==0  then high= g       /*test if the guess is too  high.      */
    if pos('low' , info)\==0  then low = g       /*  "   "  "    "    "  "   low.       */
    say                                          /*display a blank line before prompt.  */
    say $ low  '  and  '   high  "  inclusive):" /*issue the prompt message to terminal.*/
    say                                          /*display a blank line  after prompt.  */
    g= (low +  (high - low) / 2)   / 1           /*calculate the next guess & normalize.*/
    if g=oldg   then g= g + 1                    /*bump guess by one 'cause we're close.*/
    say 'My guess is'       g                    /*display computer's guess to the term.*/
    if g=?  then leave                           /*this guess is correct; leave & inform*/
    if g>?  then info= right(' Your guess is too high.', 60, "─")
            else info= right(' Your guess is too low.' , 60, "─")
    say info
    end   /*try*/
say                                              /*stick a fork in it,  we're all done. */
say 'Congratulations!   You guessed the secret number in'    #    "tries.""
