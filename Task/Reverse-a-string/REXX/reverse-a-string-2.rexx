/*REXX program to reverse a string  (and show before and after strings).*/

string1 = 'A man, a plan, a canal, Panama!'
string2 =
                                   do j=1  for length(string1)
                                   string2 = substr(string1,j,1)string2
                                   end   /*j*/
say ' original string: '  string1
say ' reversed string: '  string2
                                       /*stick a fork in it, we're done.*/
