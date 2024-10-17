; Given the remainder of the previous row and the final cons of the current row,
; extend (in situ) the current row to be a complete row of the Bell triangle.
; Return the final value in the extended row (for use in computing the following row).

(define bell-triangle-row-extend
  (lambda (prevrest thisend)
    (cond
      ((null? prevrest)
        (car thisend))
      (else
        (set-cdr! thisend (list (+ (car prevrest) (car thisend))))
        (bell-triangle-row-extend (cdr prevrest) (cdr thisend))))))

; Return the Bell triangle of rows 0 through N (as a list of lists).

(define bell-triangle
  (lambda (n)
    (let* ((tri (list (list 1)))
           (triend tri)
           (rowendval (caar tri)))
      (do ((index 0 (1+ index)))
          ((>= index n) tri)
        (let ((nextrow (list rowendval)))
          (set! rowendval (bell-triangle-row-extend (car triend) nextrow))
          (set-cdr! triend (list nextrow))
          (set! triend (cdr triend)))))))

; Print out the Bell numbers 0 through 19 and 49 thgough 51.
; (The Bell numbers are the first number on each row of the Bell triangle.)

(printf "~%The Bell numbers:~%")
(let loop ((triangle (bell-triangle 51)) (count 0))
  (when (pair? triangle)
    (when (or (<= count 19) (>= count 49))
      (printf "  ~2d: ~:d~%" count (caar triangle)))
    (loop (cdr triangle) (1+ count))))

; Print out the Bell triangle of 10 rows.

(printf "~%First 10 rows of the Bell triangle:~%")
(let rowloop ((triangle (bell-triangle 9)))
  (when (pair? triangle)
    (let eleloop ((rowlist (car triangle)))
      (when (pair? rowlist)
        (printf " ~7:d" (car rowlist))
        (eleloop (cdr rowlist))))
    (newline)
    (rowloop (cdr triangle))))
