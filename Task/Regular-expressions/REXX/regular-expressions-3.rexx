/*REXX program shows  non-destructive sub. (modeled after Perl example).*/
$string = "I am a string"
    old = " a "
    new = " another "
say 'The original string is:'  $string
say 'old  word  is:'  old
say 'new  word  is:'  new
$string2 = changestr(old,$string,new)
say 'The original string is:'  $string
say 'The  changed string is:'  $string2
                                       /*stick a fork in it, we're done.*/
