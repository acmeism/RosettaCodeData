/*REXX program to show various ways to repeat a string (or repeat a single char).*/

/*all examples are equivalent, but not created equal.*/

                           /*───────────────────────────────────────────*/
y='ha'
z=copies(y,5)
                           /*───────────────────────────────────────────*/
z=copies( 'ha', 5 )
                           /*───────────────────────────────────────────*/
y='ha'
z=y||y||y||y||y
                           /*───────────────────────────────────────────*/
y='ha'
z=y || y || y || y || y    /*same as previous, but the "big sky" version*/
                           /*───────────────────────────────────────────*/
y='ha'
z=''
       do 5
       z=z||y
       end
                           /*───────────────────────────────────────────*/
y="ha"
z=
       do 5
       z=z||y
       end
                           /*───────────────────────────────────────────*/
y="ha"
z=
       do i=101 to 105
       z=z||y
       end

                           /*───────────────────────────────────────────*/
y='+'
z=left('',5,y)
                           /*───────────────────────────────────────────*/
y='+'
z=right('',5,y)
                           /*───────────────────────────────────────────*/
y='+'
z=substr('',1,5,y)
                           /*───────────────────────────────────────────*/
y='+'
z=center('',5,y)
                           /*───────────────────────────────────────────*/
y='+'
z=centre('',5,y)
                           /*───────────────────────────────────────────*/
y='+'
z=space('',5,y)
                           /*───────────────────────────────────────────*/
y='+'
z=translate('@@@@@',y,"@")
                           /*───────────────────────────────────────────*/
y='abcdef'
z=five(y)
exit

five: procedure expose y; parse arg g
if length(g)>=5*length(y) then return g
return five(y||g)
                           /*───────────────────────────────────────────*/
y='something wicked this way comes.'
z=y||y||y||y||y||y||y||y||y||y||y||y|\y||y||y
z=left(z,5*length(y))
                           /*───────────────────────────────────────────*/
y='+'
z=copies('',5,y)
                           /*───────────────────────────────────────────*/
y='+'
z=lower('',1,5,y)
                           /*───────────────────────────────────────────*/
y='+'
z=lower('',,5,y)
                           /*───────────────────────────────────────────*/
z='+'
z=upper('',1,5,y)
                           /*───────────────────────────────────────────*/
z=upper('',,5,y)
                           /*───────────────────────────────────────────*/

y='charter bus.'
z='*****'
z=changestr('*',z,y)
                           /*───────────────────────────────────────────*/
y='what the hey!'
z=
  do until length(z)==5*length(y)
  z=z||y
  end
                           /*───────────────────────────────────────────*/
y='what the hey!'
z=
  do until length(z)==5*length(y)
  z=insert(z,0,y)
  end
                           /*───────────────────────────────────────────*/
y='yippie ki yay'
z=
   do i=1 by 5 for 5
   z=overlay(y,z,i)
   end
                           /*───────────────────────────────────────────*/
y='+'
z=justify('',5,y)
                           /*───────────────────────────────────────────*/
whatever_this_variable_is_____it_aint_referenced_directly= 'boy oh boy.'
z=; signal me; me:
  do 5
  z=z||strip(subword(sourceline(sigl-1),2),,"'")
  end
                           /*───────────────────────────────────────────*/
y="any more examples & the angry townfolk with pitchforks will burn the castle."
parse value y||y||y||y||y with z

exit                                   /*stick a fork in it, we're done.*/
