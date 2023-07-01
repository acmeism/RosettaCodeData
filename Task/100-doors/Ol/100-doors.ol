(define (flip doors every)
   (map (lambda (door num)
            (mod (+ door (if (eq? (mod num every) 0) 1 0)) 2))
      doors
      (iota (length doors) 1)))

(define doors
   (let loop ((doors (repeat 0 100)) (n 1))
      (if (eq? n 100)
         doors
         (loop (flip doors n) (+ n 1)))))

(print "100th doors: " doors)
