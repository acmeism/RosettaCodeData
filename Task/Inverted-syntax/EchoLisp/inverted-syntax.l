;; use reader macros to transform (a OP b) into (OP b a)

(lib 'match)
(define-macro invert-= (a <- b) (set! b a))
(define-macro invert-IF (a 'IF b) (when b a))

(define raining #f)

(#t <- raining)
raining
    → #t
('umbrella-need IF raining)
    → umbrella-need

(#f <- raining)
('umbrella-need IF raining)
    → #f

;; debug mode
(debug 3)
('umbrella-need IF raining)
💡 [0]     invert-IF → ('umbrella-need IF raining)
compiled :: (#when raining 'umbrella-need)
