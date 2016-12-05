/*REXX program shows how to  simultaneously  loop over  multiple  lists.*/
x = 'a b c d'
y = 'A B C'
z =  1 2 3 4 ..LAST
                     do j=1  for max(words(x), words(y), words(z))
                     say word(x,j) || word(y,j) || word(z,j)
                     end    /*j*/      /*stick a fork in it, we're done.*/
