(de ack (X Y)
   (cond
      ((=0 X) (inc Y))
      ((=0 Y) (ack (dec X) 1))
      (T (ack (dec X) (ack X (dec Y)))) ) )
