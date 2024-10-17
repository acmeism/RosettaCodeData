(define short-date
  (lambda (lt)
    (strftime "%Y-%m-%d" (localtime lt))))

(define long-date
  (lambda (lt)
    (strftime "%A, %B %d, %Y" (localtime lt))))

(define main
  (lambda (args)
    ;; Current date
    (let ((dt (car (gettimeofday))))
      ;; Short style
      (display (short-date dt))(newline)
      ;; Long style
      (display (long-date dt))(newline))))
