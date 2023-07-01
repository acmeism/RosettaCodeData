(define str "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW")
(print str)

(define rle (RLE str))
(for-each (lambda (pair)
      (print (car pair) " : " (string (cdr pair))))
   rle)
(print (decode rle))
