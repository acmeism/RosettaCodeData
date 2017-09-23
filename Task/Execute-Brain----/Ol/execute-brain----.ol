(define (bf program stack-length)
   (let ((program (string-append program "]"))
         (program-counter 0)
         (stack (make-vector stack-length 0))
         (stack-pointer 0))
      (letrec ((skip (lambda (PC sp)
                        (let loop ((pc PC) (sp sp))
                           (let ((ch (string-ref program pc))
                                 (pc (+ pc 1)))
                              (case ch
                                 (#\]  (list pc sp))
                                 (#\[  (apply loop (skip pc sp)))
                                 (else
                                    (loop pc sp)))))))
               (step (lambda (PC SP)
                        (let loop ((pc PC) (sp SP))
                           (let ((ch (string-ref program pc))
                                 (pc (+ pc 1)))
                              (case ch
                                 (#\]  (list (- PC 1) sp))
                                 (#\[  (if (eq? (vector-ref stack sp) 0)
                                          (apply loop (skip pc sp))
                                          (apply loop (step pc sp))))
                                 (#\+  (set-ref! stack sp (+ (vector-ref stack sp) 1))
                                       (loop pc sp))
                                 (#\-  (set-ref! stack sp (- (vector-ref stack sp) 1))
                                       (loop pc sp))
                                 (#\>  (loop pc (+ sp 1)))
                                 (#\<  (loop pc (- sp 1)))
                                 (#\.  (display (make-string 1 (vector-ref stack sp)))
                                       (loop pc sp))
                                 (else
                                    (loop pc sp))))))))
         (step 0 0))))

; testing:
; (bf ",++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>." 30000)
; ==> Hello World!
; (bf ">>++++[<++++[<++++>-]>-]<<.[-]++++++++++." 30000)
; ==> @
