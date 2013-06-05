/*demonstrate case insensitive REXX variable names. (for the most part).*/
dog = 'Benjamin'
Dog = 'Samba'
DOG = 'Bernie'

say copies('-',20)                     /*show a sep for visual clarity. */
say 'dog=' dog
say 'Dog=' Dog
say 'DOG=' DOG
say copies('-',20)                     /*show a sep for visual clarity. */
say

x='dog';  dogname.x='Benjamin'
x='Dog';  dogname.x='Samba'
x='DOG';  dogname.x='Bernie'

say copies('=',20)                     /*show a sep for visual clarity. */
_='dog';  say 'dog=' dogname._
_='Dog';  say 'Dog=' dogname._
_='DOG';  say 'DOG=' dogname._
say copies('=',20)                     /*show a sep for visual clarity. */
                                       /*stick a fork in it, we're done.*/
