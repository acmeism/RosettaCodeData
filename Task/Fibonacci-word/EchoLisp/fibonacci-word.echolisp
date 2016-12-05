(lib 'struct)
(struct FW ( count0 count1 length string)) ;; a fibonacci word
(define (F-word n) ;; generator
    (define a (F-word (1- n)))
    (define b (F-word (- n 2)))
    (FW
        (+ (FW-count0 a) (FW-count0 b))
        (+ (FW-count1 a) (FW-count1 b))
        (+ (FW-length a) (FW-length b))
        (if (> n 9) "..." (string-append (FW-string a) (FW-string b)))))

(remember 'F-word (vector 0 (FW 0 1 1 "1") (FW 1 0  1 "0")))

(define (entropy fw)
    (define p (// (FW-count0 fw) (FW-length fw)))
    (cond
    ((= p 0) 0)
    ((= p 1) 0)
        (else (- 0 (* p (log2 p)) (* (- 1 p) (log2 (- 1 p)))))))


(define (task (n 38) (fw))
    (for ((i (in-range 1 n)))
        (set! fw (F-word i))
        (printf "%3d %10d %24d %a"
            i (FW-length fw) (entropy fw) (FW-string fw))))
