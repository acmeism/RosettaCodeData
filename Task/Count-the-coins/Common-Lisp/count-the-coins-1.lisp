(defun count-change (amount coins
                    &optional
                    (length (1- (length coins)))
                    (cache  (make-array (list (1+ amount) (length coins))
                                        :initial-element nil)))
  (cond ((< length 0) 0)
        ((< amount 0) 0)
        ((= amount 0) 1)
        (t (or (aref cache amount length)
               (setf (aref cache amount length)
                     (+ (count-change (- amount (first coins)) coins length cache)
                        (count-change amount (rest coins) (1- length) cache)))))))

; (compile 'count-change) ; for CLISP

(print (count-change 100 '(25 10 5 1)))		   ; = 242
(print (count-change 100000 '(100 50 25 10 5 1)))  ; = 13398445413854501
(terpri)
