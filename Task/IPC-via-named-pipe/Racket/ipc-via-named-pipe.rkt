#lang racket

(define-values (in out) (make-pipe))

;; Thread loops through list of strings to send
;; and closes port when finished
(define t1 (thread (lambda ()
                     (for ([i (list "a" "test" "sequence")])
                       (display i out)
                       (sleep 1))
                     (close-output-port out))))

;; Blocking call to read char, if not EOF then loop
(define t2 (thread (lambda ()
                     (define cnt 0)
                     (let loop ()
                       (when (not (eof-object? (read-char in)))
                         (set! cnt (add1 cnt))
                         (loop)))
                     (display (format "Bytes Rx: ~a\n" cnt))
                     (close-input-port in))))

(thread-wait t1)
(thread-wait t2)
