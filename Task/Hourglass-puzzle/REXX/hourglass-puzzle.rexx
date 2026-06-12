/*REXX program determines  if there is a  solution  to measure  9 minutes  using a      */
/*──────────────────────────────────── four and seven minute sandglasses.               */
t4= 0
mx= 10000
           do t4=0  by 4  to mx
           t7_left= 7   -   t4 % 7
           if t7_left==9-4  then leave
           end   /*t4*/
say
if t4>mx  then do
               say 'Not found.'
               exit 4
               end

say "Turn over both sandglasses  (at the same time)  and continue"
say "flipping them each when the sandglasses individually run down"
say "until the four-minute glass is flipped "       t4%4      ' times,'
say "whereupon the seven-minute glass is immediately placed on its"
say "side with "        t7_left        ' minutes of sand in it.'
say
say "You can measure 9 minutes by flipping the four-minute glass"
say "once,  then flipping the remaining sand in the seven-minute"
say "glass when the four-minute glass ends."
say
exit 0
