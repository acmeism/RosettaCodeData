/*REXX program shows  test and substitute  (modeled after Perl example).*/
 $string = "I am a string"
     old = " am "
     new = " was "
say 'The original string is:'  $string
say 'old  word  is:'           old
say 'new  word  is:'           new

if wordpos(old,$string)\==0  then
           do
           $string = changestr(old,$string,new)
           say 'I was able to find and replace ' old " with " new
           end
                                       /*stick a fork in it, we're done.*/
