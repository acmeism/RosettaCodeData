  do j=1  to 10
  say 'j=' j
  if j>5  then leave
  say 'negative j='  (-j)
  end   /*j*/

say 'end of the DO loop for j.'

ouch=60
sum=0
                do k=0  to 100  by 3
                say 'k=' k
                           do m=1  to k
                           if m=ouch  then leave k
                           sum=sum+m
                           end   /*m*/
                end              /*k*/
say 'sum=' sum
