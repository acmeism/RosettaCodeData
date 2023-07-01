;; use task [[RPN_to_infix_conversion#EchoLisp]] to print results
(define (rpn->string rpn)
    (if (vector? rpn)
        (infix->string (rpn->infix rpn))
        "😥 Not found"))


(string-delimiter "")
(define OPS #(*  + - // )) ;; use float division
(define-syntax-rule (commutative? op) (or (= op *) (= op +)))

;; ---------------------------------
;; calc rpn -> num value or #f if bad rpn
;; rpn is a vector of ops or numbers
;; ----------------------------------
(define (calc rpn)
(define S (stack 'S))
    (for ((token rpn))
        (if (procedure? token)
            (let [(op2 (pop S)) (op1 (pop S))]
                (if (and op1 op2)
                (push S (apply token (list op1 op2)))
                (push S #f))) ;; not-well formed
        (push S token ))
        #:break (not (stack-top S)))
    (if (= 1 (stack-length S)) (pop S) #f))

;; check for legal rpn -> #f if not legal
(define (rpn? rpn)
(define S (stack 'S))
    (for ((token rpn))
        (if (procedure? token)
            (push S (and (pop S) (pop S)))
            (push S token ))
        #:break (not (stack-top S)))
    (stack-top S))

;; --------------------------------------
;; build-rpn : push next rpn op or number
;; dleft is number of not used digits
;; ---------------------------------------
(define count 0)

(define (build-rpn into: rpn  depth  maxdepth  digits  ops dleft target &hit )
(define cmpop #f)
    (cond
;; tooo long
    [(> (++ count) 200_000) (set-box! &hit 'not-found)]
;; stop on first hit
    [(unbox &hit) &hit]
;; partial rpn must be legal
    [(not (rpn? rpn)) #f]
;; eval rpn if complete
    [(> depth maxdepth)
        (when (= target (calc rpn))  (set-box! &hit rpn))]
;;  else, add a digit to rpn
    [else
    [when (< depth maxdepth)  ;; digits anywhere except last
        (for [(d digits) (i 10)]
                #:continue (zero? d)
                (vector-set! digits i 0) ;; mark used
                (vector-set! rpn depth d)
                (build-rpn rpn (1+ depth) maxdepth  digits  ops (1- dleft)  target &hit)
                (vector-set! digits i d)) ;; mark unused
                ] ;; add digit
;; or,  add an op
;; ops anywhere except  positions 0,1
    [when  (and (> depth 1) (<= (+ depth dleft) maxdepth));; cutter : must use all digits
    (set! cmpop
        (and (number? [rpn (1- depth)])
             (number? [rpn (- depth 2)])
              (> [rpn (1- depth)]  [rpn (- depth 2)])))

        (for [(op ops)]
            #:continue (and cmpop (commutative? op)) ;; cutter : 3 4 + ===  4 3 +
            (vector-set! rpn depth op)
            (build-rpn rpn (1+ depth) maxdepth  digits  ops dleft target &hit)
            (vector-set! rpn depth 0))] ;; add op
        ] ; add something to rpn vector
        )) ; build-rpn

;;------------------------
;;gen24 : num random numbers
;;------------------------
(define (gen24 num maxrange)
     (->> (append (range 1 maxrange)(range 1 maxrange)) shuffle (take num)))

;;-------------------------------------------
;; try-rpn : sets starter values for build-rpn
;;-------------------------------------------
(define (try-rpn digits target)
    (set! digits (list-sort > digits)) ;; seems to accelerate things
    (define rpn (make-vector (1- (* 2 (length digits)))))
    (define &hit (box #f))
    (set! count 0)

    (build-rpn rpn starter-depth: 0
        max-depth: (1- (vector-length rpn))
         (list->vector digits)
         OPS
        remaining-digits: (length digits)
        target &hit )
    (writeln  target '=   (rpn->string (unbox &hit)) 'tries= count))

;; -------------------------------
;; (task numdigits target maxrange)
;; --------------------------------
(define (task (numdigits 4) (target 24) (maxrange 10))
        (define digits (gen24 numdigits maxrange))
        (writeln digits '→ target)
        (try-rpn digits target))
