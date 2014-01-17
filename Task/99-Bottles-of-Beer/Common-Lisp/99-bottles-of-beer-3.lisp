(format t "~{~[~^~]~:*~D bottle~:P of beer on the wall~%~:*~D bottle~:P of beer~%Take one down, pass it around~%~D bottle~:P~:* of beer on the wall~2%~}"
          (loop :for n :from 99 :downto 0 :collect n))
