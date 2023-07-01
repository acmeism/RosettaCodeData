(setf test-strings '("1001110011"
                     "1110111011"
                     "0010010010"
                     "1010101010"
                     "1111111111"
                     "0100101101"
                     "0100100"
                     "101"
                     "11"
                     "00"
                     "1"
                     ))

(loop for item in test-strings
      collecting (cons item (rep-stringv item)))
