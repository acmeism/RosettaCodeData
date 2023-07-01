/*REXX program plays guess the number  game with a human;  the computer picks the number*/
  low=   1                                       /*the lower range for the guessing game*/
 high= 100                                       /* "  upper   "    "   "      "      " */
  try=   0                                       /*the number of valid (guess) attempts.*/
    r= random(low, high)                         /*get a random number  (low ───► high).*/
 lows= 'too_low  too_small too_little below under underneath   too_puny'
highs= 'too_high too_big   too_much   above over  over_the_top too_huge'
  erm= '***error***'
 @gtn= "guess the number, it's between"
prompt= centre(@gtn   low     'and'     high     '(inclusive)  ───or───  Quit:', 79, "─")
                                                 /* [↓]  BY 0 ─── used to  LEAVE  a loop*/
  do ask=0  by 0;     say;      say prompt;      say;     pull g;     g= space(g);    say
    do validate=0  by 0                          /*DO index required; LEAVE instruction.*/
       select
       when g==''                 then iterate ask
       when abbrev('QUIT', g, 1)  then exit                              /*what a whoos.*/
       when words(g) \== 1        then say erm    'too many numbers entered:'        g
       when \datatype(g, 'N')     then say erm g  "isn't numeric"
       when \datatype(g, 'W')     then say erm g  "isn't a whole number"
       when g<low                 then say erm g  'is below the lower limit of'     low
       when g>high                then say erm g  'is above the higher limit of'   high
       otherwise       leave  /*validate*/
       end   /*select*/
    iterate ask
    end      /*validate*/

  try= try + 1
  if g=r  then leave
  if g>r  then what= word(highs, random(1, words(highs) ) )
          else what= word( lows, random(1, words( lows) ) )
  say 'your guess of'     g     "is"      translate(what, , "_").
  end        /*ask*/
                                                 /*stick a fork in it,  we're all done. */
if try==1  then say 'Gadzooks!!!       You guessed the number right away!'
           else say 'Congratulations!, you guessed the number in '     try     " tries."
