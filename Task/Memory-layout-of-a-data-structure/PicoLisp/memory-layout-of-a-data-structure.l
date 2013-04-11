# Define bit constants
(for (N . Mask) '(CD RD TD DTR SG DSR RTS CTS RI)
   (def Mask (>> (- 1 N) 1)) )

# Test if Clear to send
(when (bit? CTS Data)
   ... )
