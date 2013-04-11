[ack
       [ [pop zero?] [ [m n : [n succ]] view i]
         [zero?]     [ [m n : [m pred 1 ack]] view i]
         [true]      [ [m n : [m pred m n pred ack ack]] view i]
       ] when].
