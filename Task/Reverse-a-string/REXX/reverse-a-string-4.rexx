/*REXX program to reverse a string  (and show before and after strings).*/

string1 = 'A man, a plan, a canal, Panama!'
string2 =
                                  do j=length(string1)  to 1  by -1
                                  string2 = string2 || substr(string1,j,1)
                                  end   /*j*/
say ' original string: '  string1
say ' reversed string: '  string2
                                       /*stick a fork in it, we're done.*/
