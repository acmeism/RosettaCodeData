(load "@lib/ps.l")

(call 'lpr
   (pdf "pinstripes"
      (a4)  # 595 x 842 dots
      (for X 595
         (gray (if (bit? 1 X) 0 100)
            (vline X 0 842) ) )
      (page) ) )
