(load "@lib/ps.l")

# Using circular lists for an endless supply of colors
#      (black  red  green blue magenta cyan yellow white)
(setq
   Red   (0    100    0     0    100    0    100   100 .)
   Green (0     0    100    0     0    100   100   100 .)
   Blue  (0     0     0    100   100   100    0    100 .) )

(call 'lpr
   (pdf "pinstripes"
      (a4)  # 595 x 842 dots
      (let (I 0  Step 1)
         (for X 595
            (color (car Red) (car Green) (car Blue)
               (vline X 0 842) )
            (when (= Step (inc 'I))
               (zero I)
               (pop 'Red)
               (pop 'Green)
               (pop 'Blue) )
            (when (=0 (% X 72))  # 1 inch
               (zero I)
               (inc 'Step) ) ) )
      (page) ) )
