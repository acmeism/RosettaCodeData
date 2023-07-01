(require 'hash)
(require 'tree)

(define OPS (make-hash))
(hash-set OPS "^" '(  4 #f)) ;; right assoc
(hash-set OPS "*" '(  3 #t)) ;; left assoc
(hash-set OPS "/" '(  3 #t))
(hash-set OPS "+" '(  2 #t))
(hash-set OPS "-" '(  2 #t))

;; helpers
(define (is-right-par? token) (string=? token ")"))
(define (is-left-par? token)  (string=? token "("))
(define (is-num? op)   (not (hash-ref OPS op))) ;; crude
(define (is-op? op)    (hash-ref OPS op))
(define (is-left? op)  (second (hash-ref OPS op)))
(define (is-right? op) (not (is-left? op)))
(define (op-prec op)   (first (hash-ref OPS op)))

;; Wikipedia algorithm, translated as it is

(define (shunt tokens S Q)
    (for ((token tokens))
     (writeln "S: " (stack->list S) "Q: " (queue->list Q) "token: "token)
    (cond
    [(is-left-par? token) (push S token) ]
    [(is-right-par? token)
        (while (and (stack-top S) (not (is-left-par? (stack-top S))))
               (q-push Q ( pop S)))
        (when (stack-empty? S) (error 'misplaced-parenthesis "()" ))
        (pop S)] ; // left par

    [(is-op? token)
            (while (and
                (is-op? (stack-top S))
                (or
                  (and (is-left? token) (<= (op-prec token) (op-prec (stack-top S))))
                  (and (is-right? token) (< (op-prec token) (op-prec (stack-top S))))))
                (q-push Q (pop S)))
        (push S token)]

    [(is-num? token) (q-push Q token)]
    [else (error 'bad-token token)])) ; for
    (while (stack-top S) (q-push Q (pop S))))

(string-delimiter "")
(define (task infix)
    (define S (stack 'S))
    (define Q (queue 'Q))
        (shunt (text-parse infix) S Q)
        (writeln 'infix infix)
        (writeln 'RPN (queue->list Q)))
