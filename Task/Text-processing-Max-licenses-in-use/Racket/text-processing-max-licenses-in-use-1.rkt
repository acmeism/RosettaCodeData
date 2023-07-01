#lang racket
;;; reads a licence file on standard input
;;; returns max licences used and list of times this occurred
(define (count-licences)
  (let inner ((ln (read-line)) (in-use 0) (max-in-use 0) (times-list null))
    (if (eof-object? ln)
        (values max-in-use (reverse times-list))
        (let ((mtch (regexp-match #px"License (IN |OUT) @ (.*) for job.*" ln)))
          (cond
            [(string=? "OUT" (second mtch))
             (let ((in-use+1 (add1 in-use)))
               (cond
                 [(> in-use+1 max-in-use)
                  (inner (read-line) in-use+1 in-use+1 (list (third mtch)))]
                 [(= in-use+1 max-in-use)
                  (inner (read-line) in-use+1 max-in-use (cons (third mtch) times-list))]
                 [else (inner (read-line) in-use+1 max-in-use times-list)]))]
            [(string=? "IN " (second mtch))
             (inner (read-line) (sub1 in-use) max-in-use times-list)]
            [else (inner (read-line) in-use max-in-use times-list)])))))

(define-values (max-used max-used-when)
(with-input-from-file "mlijobs.txt" count-licences))
(printf "Maximum licences in simultaneously used is ~a at the following times:~%"
        max-used)
(for-each displayln max-used-when)
