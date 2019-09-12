(let multiply ((x n) (y m))
   (* x y))

; example of naive multiplication function implementation using local recursion:
(define (multiply x y)
   (let loop ((y y) (n 0))
      (if (= y 0)
         n
         (loop (- y 1) (+ n x)))))

(print (multiply 7 8))
; ==> 56
