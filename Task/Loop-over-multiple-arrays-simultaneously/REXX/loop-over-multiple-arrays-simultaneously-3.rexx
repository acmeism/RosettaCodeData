/*REXX program shows how to  simultaneously  loop over  multiple  lists.*/
x = 'a b c d'
y = 'A B C'
z =  1 2 3 4
               do j=1  until  output=''
               output = word(x,j) || word(y,j) || word(z,j)
               say output
               end    /*j*/            /*stick a fork in it, we're done.*/
