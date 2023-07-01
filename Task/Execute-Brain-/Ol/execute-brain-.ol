(define (bf program stack-length)
   (let ((program (string-append program "]")); end
         (program-counter 0)
         (stack (make-bytevector stack-length 0))
         (stack-pointer 0))
      (letrec ((skip (lambda (PC sp in)
                        (let loop ((pc PC) (sp sp) (in in))
                           (let ((ch (string-ref program pc))
                                 (pc (+ pc 1)))
                              (case ch
                                 (#\]  (list pc sp in))
                                 (#\[  (apply loop (skip pc sp in)))
                                 (else
                                    (loop pc sp in)))))))
               (step (lambda (PC SP IN)
                        (let loop ((pc PC) (sp SP) (in IN))
                           (let ((ch (string-ref program pc))
                                 (pc (+ pc 1)))
                              (case ch
                                 (#\]  (list (- PC 1) sp in)) ; the end
                                 (#\[  (if (eq? (ref stack sp) 0)
                                          (apply loop (skip pc sp in))
                                          (apply loop (step pc sp in))))
                                 (#\+  (set-ref! stack sp (mod (+ (ref stack sp) 257) 256))
                                       (loop pc sp in))
                                 (#\-  (set-ref! stack sp (mod (+ (ref stack sp) 255) 256))
                                       (loop pc sp in))
                                 (#\>  (loop pc (+ sp 1) in))
                                 (#\<  (loop pc (- sp 1) in))
                                 (#\.  (display (string (ref stack sp)))
                                       (loop pc sp in))
                                 (#\,  (let this ((in in))
                                          (cond
                                             ((pair? in)
                                                (set-ref! stack sp (car in))
                                                (loop pc sp (cdr in)))
                                             ((null? in)
                                                (set-ref! stack sp 0)
                                                (loop pc sp in))
                                             (else
                                                (this (force in))))))
                                 (else ; skip any invalid character
                                    (loop pc sp in))))))))
         (step 0 0 (port->bytestream stdin)))))
