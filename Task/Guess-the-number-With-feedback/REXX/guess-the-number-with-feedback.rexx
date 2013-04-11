/*REXX program that plays the guessing (the number) game.               */
 low=1                                 /*lower range for guessing game. */
high=100                               /*upper range for guessing game. */
try=0                                  /*number of valid attempts.      */
r=random(1,100)                        /*get a random #  (low ──> high).*/
 lows='too_low  too_small too_little below under underneath   too_puny'
highs='too_high too_big   too_much   above over  over_the_top too_huge'
er!='*** error! ***'
prompt=centre("guess the number, it's between" low 'and',
      high '(inclusive)  ───or───  Quit:',79,"─")

  do ask=0;    say;    say prompt;    say;    pull g;    g=space(g);   say
    do validate=0
       select
       when g==''              then iterate ask
       when abbrev('QUIT',g,1) then exit
       when words(g)\==1       then say er! 'too many numbers entered:' g
       when \datatype(g,'N')   then say er! g "isn't numeric"
       when \datatype(g,'W')   then say er! g "isn't a whole number"
       when g<low              then say er! g 'is below the lower limit of' low
       when g>high             then say er! g 'is above the higher limit of' high
       otherwise leave validate
       end    /*select*/
    iterate ask
    end       /*validate*/

  try=try+1
  if g=r  then leave
  if g>r  then what=word(highs,random(1,words(highs)))
          else what=word( lows,random(1,words( lows)))
  say 'your guess of' g "is" translate(what'.',,"_")
  end         /*ask*/

if try==1 then say 'Gadzooks!!!    You guessed the number right away!'
          else say 'Congratulations!, you guessed the number in' try "tries."
                                       /*stick a fork in it, we're done.*/
