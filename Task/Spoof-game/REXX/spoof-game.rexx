/*REXX program plays the "spoof" game with a human player (does presentation & scoring).*/
parse arg seed .;  if datatype(seed, 'W')  then call random ,,seed   /*use RANDOM seed? */
__= copies('─', 9)                               /*literal used in the game's prompting.*/

  do forever                                     /*$ = computer;   @ = human or CBLF.   */
       do until $pot+3<$g;  $pot = random(0, 3)  /*get a computer number for the pot.   */
                            $g   = random(0, 6)  /* "  "    "        "    "   "  guess. */
       end   /*until*/
  say
  say copies('─', 55);      say __ "The computer has got a pot and a guess."
  @pot= 0
  @pot= prompt(__ 'What is your pot?         (or  QUIT)'    )
  @g=   prompt(__ 'What is your guess?       (or  QUIT)',  .)
  say __  "The computer's  pot  is: "  $pot
  say __  "The computer's guess is: "  $g
  pot= $pot + @pot
  say
         select
         when $g==pot  &  @g==pot  then say __ 'This game is a draw.'
         when $g==pot              then say __ 'This game won by the computer.'
         when @g==pot              then say __ 'This game won by you.    Congratulations!'
         otherwise                      say __ 'This game has no winner.'
         end   /*select*/
  end          /*forever*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
prompt:  do forever;   er= __ '***error*** ';     say arg(1);       parse pull # y . 1 _,?
         upper #;      if abbrev('QUIT', #, 1)  then exit 1       /*user wants to quit? */
         if #==''             then do; say er "no argument entered."        ; iterate; end
         if y\==''            then do; say er "too many arguments:"        _; iterate; end
         if \datatype(#,'N')  then do; say er "argument isn't numeric:"    #; iterate; end
         if \datatype(#,'W')  then do; say er "argument isn't an integer:" #; iterate; end
         if ?==. & @pot+3>=#  then do; say er "illegal input for guess:"   #; iterate; end
         #= # / 1;            return #
         end   /*forever*/
