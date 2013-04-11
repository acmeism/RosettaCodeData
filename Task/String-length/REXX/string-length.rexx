/*REXX program to show lengths (in bytes/characters) for various strings*/
    /*            1         */               /*a handy over/under scale.*/
    /*   123456789012345    */
hello = 'Hello, world!'   ;    say  'length of HELLO is '   length(hello)
happy = 'Hello, world! ☺' ;    say  'length of HAPPY is '   length(happy)
jose  = 'José'            ;    say  'length of  JOSE is '   length(jose)
nill  = ''                ;    say  'length of  NILL is '   length(nill)
null  =                   ;    say  'length of  NULL is '   length(null)
sum   = 5+1               ;    say  'length of   SUM is '   length(sum)
                                       /*stick a fork in it, we're done.*/
