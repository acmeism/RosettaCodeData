# Ackermann
(de ack (F)
   (curry (F) (X Y)
      (cond
         ((=0 X) (inc Y))
         ((=0 Y) (F (dec X) 1))
         (T (F (dec X) (F X (dec Y)))) ) ) )

: ((Y ack) 3 4)
-> 125
