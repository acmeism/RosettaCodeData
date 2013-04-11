/*REXX program demonstrates  substitution  (modeled after Perl example).*/
$string = "I am a string"
    old = " a "
    new = " another "
say 'The original string is:'  $string
say 'old  word  is:'  old
say 'new  word  is:'  new
$string = changestr(old,$string,new)
say 'The  changed string is:'  $string
                                       /*stick a fork in it, we're done.*/
