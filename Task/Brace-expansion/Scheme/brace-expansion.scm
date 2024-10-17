(define (parse-brackets str)
  ;; We parse the bracketed strings using an accumulator and a stack
  ;;
  ;; lst is the stream of tokens
  ;; acc is the accumulated list of "bits" in this branch
  ;; stk is a list of partially completed accumulators
  ;;
  (let go ((lst (string->list str))
           (acc '())
           (stk '()))
    (cond ((null? lst)
           (unless (null? stk)
             (error "parse-brackets" 'non-empty-stack))
           (comma-sep acc))
          ((eq? (car lst) #\{)
           (go (cdr lst)
               '()
               (cons acc stk)))
          ((eq? (car lst) #\})
           (when (null? stk)
             (error "parse-brackets" 'empty-stack))
           (go (cdr lst)
               (cons (comma-sep acc) (car stk))
               (cdr stk)))
          (else
           (go (cdr lst)
               (cons (car lst) acc)
               stk)))))

(define (comma-sep lst)
  ;; This function is applied to the accumulator, it does three things:
  ;; - it reverses the list
  ;; - joins characters into short strings
  ;; - splits the strings based on commas
  ;;
  (let go ((lst lst)
           (acc '())
           (rst '()))
    (if (null? lst)
        (cons (list->string acc) rst)
        (cond ((eq? #\, (car lst))
               (go (cdr lst)
                   '()
                   (cons (list->string acc) rst)))
              ((char? (car lst))
               (go (cdr lst)
                   (cons (car lst) acc)
                   rst))
              (else
               (go (cdr lst)
                   '()
                   (cons (car lst)
                         (cons (list->string acc)
                               rst))))))))

;; We use the list monad for the nondeterminism needed to expand out every possible bracket option

(define (concatenate lists)
  (apply append lists))

(define (return x)
  (list x))
(define (>>= l f)
  (concatenate (map f l)))

(define (sequence lsts)
  (if (null? lsts)
      (return '())
      (>>= (car lsts)
           (lambda (option)
             (>>= (sequence (cdr lsts))
                  (lambda (tail)
                    (return (cons option tail))))))))

(define (expand-inner tree)
  (if (string? tree)
      (return tree)
      (>>= tree
           (lambda (option)
             (expand-inner option)))))

(define (expand tree)
  (define (string-append* lst) (apply string-append lst))
  (map string-append* (sequence (map expand-inner tree))))

(define (bracket-expand str)
  (expand (parse-brackets str)))

(bracket-expand "It{{em,alic}iz,erat}e{d,}")
;; '("Ited" "Ite" "Itemed" "Iteme" "Italiced" "Italice" "Itized" "Itize" "Iterated" "Iterate")
