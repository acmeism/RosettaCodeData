/*REXX program displays the lengths  (in bytes/characters)  for various strings.        */
    /*            1         */                         /*a handy-dandy over/under scale.*/
    /*   123456789012345    */
hello = 'Hello, world!'      ;        say  'the length of HELLO is '   length(hello)
happy = 'Hello, world! ☺'    ;        say  'the length of HAPPY is '   length(happy)
jose  = 'José'               ;        say  'the length of  JOSE is '   length(jose)
nill  = ''                   ;        say  'the length of  NILL is '   length(nill)
null  =                      ;        say  'the length of  NULL is '   length(null)
sum   = 5+1                  ;        say  'the length of   SUM is '   length(sum)
                                                       /*   [↑]  is, of course,  6.     */
                                                       /*stick a fork in it, we're done.*/
