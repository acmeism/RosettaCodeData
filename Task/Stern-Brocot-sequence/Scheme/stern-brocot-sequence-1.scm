; Recursive function to return the Nth Stern-Brocot sequence number.

(define stern-brocot
  (lambda (n)
    (cond
      ((<= n 0)
        0)
      ((<= n 2)
        1)
      ((even? n)
        (stern-brocot (/ n 2)))
      (else
        (let ((earlier (/ (1+ n) 2)))
          (+ (stern-brocot earlier) (stern-brocot (1- earlier))))))))
