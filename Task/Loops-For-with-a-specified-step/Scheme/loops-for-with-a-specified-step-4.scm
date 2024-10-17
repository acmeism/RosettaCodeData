(define-syntax for-loop
  (syntax-rules ()
    ((for-loop index start end step body ...)
     (let ((evaluated-end end) (evaluated-step step))
       (let loop ((i start))
         (if (< i evaluated-end)
           ((lambda (index) body ... (loop (+ i evaluated-step))) i)))))))

(for-loop i 2 9 2
  (display i)
  (newline))
