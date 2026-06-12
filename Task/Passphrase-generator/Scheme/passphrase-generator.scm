(define (read-lines filename)
  (call-with-input-file filename
    (lambda (port)
      (let loop ((lines '()))
        (let ((line (read-line port 'any)))
          (if (eof-object? line)
              (reverse lines)
              (loop (cons line lines))))))))

(define (join lst sep)
  (if (null? lst)
      ""
      (let loop ((xs (cdr lst)) (acc (car lst)))
        (if (null? xs)
            acc
            (loop (cdr xs)
                  (string-append acc sep (car xs)))))))

(define (random-unique n max)
  ;; n unique integers in [0, max-1]
  (let loop ((result '()))
    (if (= (length result) n)
        (reverse result)
        (let ((r (random max)))
          (if (member r result)
              (loop result)
              (loop (cons r result)))))))

(define (capitalize s)
  (if (zero? (string-length s))
      s
      (string-append
       (string-upcase (substring s 0 1))
       (string-downcase (substring s 1)))))

(define (passphrase n candidates)
  (let* ((nc (length candidates)))
    (if (or (< n 3) (> n 7) (= nc 0))
        ""
        (let* ((idxs (random-unique n nc))
               (nums (random-unique n 90)) ; 0..89
               (nums2 (map (lambda (x) (+ 10 x)) nums))
               (words (map (lambda (i) (list-ref candidates i)) idxs))
               (final (map (lambda (w n)
                             (string-append (capitalize w)
                                            (number->string n)))
                           words nums2)))
          (join final "-")))))

;; --- Main program ---
(define all-words (read-lines "unixdict.txt"))

(define candidates
  (filter (lambda (w)
            (let ((l (string-length w)))
              (and (> l 3) (< l 10))))
          all-words))

(do ((i 0 (+ i 1)))
    ((= i 5))
  (display (passphrase 5 candidates))
  (newline))
