;;; create sample associative array
(define aa (list->ff '(
   (hello . 1)
   (world . 2)
   (! . 3))))

(print aa)
; ==> #((! . 3) (hello . 1) (world . 2))

;;; simplest iteration over all associative array (using ff-iter, lazy iterator)
(let loop ((kv (ff-iter aa)))
   (cond
      ((null? kv) #true)
      ((pair? kv)
         (print (car kv))
         (loop (cdr kv)))
      (else (loop (force kv)))))
; ==> (! . 3)
; ==> (hello . 1)
; ==> (world . 2)

;;; iteration with returning value (using ff-fold)
(print
   "folding result: "
   (ff-fold
      (lambda (result key value)
         (print "key: " key ", value: " value)
         (+ result 1))
      0
      aa))

; ==> key: !, value: 3
; ==> key: hello, value: 1
; ==> key: world, value: 2
; ==> folding result: 3

;;; same but right fold (using ff-foldr)
(print
   "rfolding result: "
   (ff-foldr
      (lambda (result key value)
         (print "key: " key ", value: " value)
         (+ result 1))
      0
      aa))

; ==> key: world, value: 2
; ==> key: hello, value: 1
; ==> key: !, value: 3
; ==> rfolding result: 3

;;; at least create new array from existing (let's multiply every value by value)
(define bb (ff-map aa
      (lambda (key value)
         (* value value))))
(print bb)

; ==> #((! . 9) (hello . 1) (world . 4))
