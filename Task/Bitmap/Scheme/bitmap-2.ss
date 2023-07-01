(define (make-image columns rows)
  (if (= rows 0)
      (list)
      (cons (make-list columns (list)) (make-image columns (- rows 1)))))

(define (image-fill! image colour)
  (if (not (null? image))
      (begin (list-fill! (car image) colour) (image-fill! (cdr image) colour))))

(define (image-set! image column row colour)
  (list-set! (list-get image row) column colour))

(define (image-get image column row)
  (list-get (list-get image row) column))
