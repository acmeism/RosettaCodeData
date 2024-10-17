(define (for-each-tail _func _list)
  (until (empty? _list)
    (_func _list)
    (pop _list)))

(for-each-tail
  (fn (xs)
    (print (xs 0))
    (if (rest xs) (print ", ")))
  (sequence 1 10))
