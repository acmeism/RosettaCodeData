/*REXX program demonstrates   testing      (modeled after Perl example).*/
$string="I am a string"
                                                  say 'The string is:'  $string
x="string" ;  if right($string,length(x))=x  then say 'It ends with:'  x
y="You"    ;  if left($string,length(y))\=y  then say 'It does not start with:'  y
z="ring"   ;  if pos(z,$string)\==0          then say 'It contains the string:'  z
z="ring"   ;  if wordpos(z,$string)==0       then say 'It does not contain the word:'  z
                                       /*stick a fork in it, we're done.*/
