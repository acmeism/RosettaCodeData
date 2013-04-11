[ack
       [ [pop zero?] [popd succ]
         [zero?]     [pop pred 1 ack]
         [true]      [[dup pred swap] dip pred ack ack ]
       ] when].
