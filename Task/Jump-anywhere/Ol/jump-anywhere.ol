; recursion:
(let loop ((n 10))
   (unless (= n 0)
      (loop (- n 1))))

; continuation
(call/cc (lambda (break)
   (let loop ((n 10))
      (if (= n 0)
         (break 0))
      (loop (- n 1)))))

(print "ok.")
