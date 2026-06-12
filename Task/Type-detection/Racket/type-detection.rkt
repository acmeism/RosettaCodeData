#lang racket

(require racket/undefined)

(define fooer<%> (interface ()))
(define foo% (class* object% (fooer<%>)
               (super-new)))

(struct my-tree (l v r))
;; -----------------------------------------------------------------------------
(define (n.t f)
  (list f (regexp-replace #rx"\\?" (symbol->string (object-name f)) "")))

;; listed in the order (as close as) shown in
;; http://docs.racket-lang.org/guide/datatypes.html (section numbers next to
;; some entries)
(define type-tests.names
  `(,@(map n.t
           (list boolean? immutable? ; 3.1
                 ))
    ;; the famous scheme numerical tower
    ,@(map n.t ; 3.2
           (list number? complex? real? rational? integer? exact-integer?
                 exact-nonnegative-integer? exact-positive-integer?
                 inexact-real? fixnum? flonum? double-flonum? single-flonum?
                 zero? positive? negative? odd? even? exact? inexact?))
    ,@(map n.t
           (list char? ; 3.3 --- there are also char-alphabetic? etc -- but they're not
                       ;         types as such
                 string? ; 3.4
                 byte? bytes? ; 3.5
                 symbol? ; 3.6
                 keyword? ; 3.7
                 pair? null? list? ; 3.8
                 vector? ; 3.9
                 hash? hash-equal? hash-eqv? hash-eq? hash-weak? ; 3.10
                 box? ; 3.11
                 void? ; 3.12
                 ))
    ,(list (λ (v) (eq? v undefined)) "undefined") ; 3. 12
    ;; now we move to http://docs.racket-lang.org/reference/data.html
    ;; for section numbering
    ,@(map n.t
           (list
            regexp? pregexp? byte-regexp? byte-pregexp? ; 4.7
            stream? sequence? ; 4.14
            dict? ; 4.15
            set-equal? set-eqv? set-eq? set? set-mutable? set-weak? ; 4.16
            continuation? procedure? ; 4.17
            ))
    ;; class/interface testing
    ,(list (λ (v) (is-a? v object%)) "object%")
    ,(list (λ (v) (is-a? v foo%)) "foo%")
    ,(list (λ (v) (is-a? v fooer<%>)) "fooer<%>")

    ;; more types from reference (sections are top-level, mostly)
    ,@(map n.t
           (list
            syntax? ; 3.
            my-tree? ; 5.
            exn? exn:fail? exn:fail:filesystem? ; 10.2
            promise? ; 10.3
            ))

    ;; there's all sorts of other types to test!
    ))

(define (->type-names v)
  (let ((rv (for/list ((t.n (in-list type-tests.names))
                       #:when (with-handlers
                                  ((exn? (λ (x) #f)))
                                ((car t.n) v))) (cadr t.n))))
    (if (null? rv) (list "UNKNOWN") rv)))

(module+ test
  (require xml/xml)

  (define test-values
    (list 3.+4.i 3+4i (- pi) pi 0. 0 -0.5 0.5 -1/3 1/3
          -12345678909876543210123456789 12345678909876543210123456788 -132 133
          #\t #\null
          "" "monkeys" "\u03BB"
          -1 255 256
          #"" #"nibble"
          'hello '||
          '#:woo
          '() '(1 . 2) '(3) '(5 6)

          #() #(1) #("foo" 2 'bar)

          (make-hash)
          (make-hasheq)
          (make-hasheqv)
          (hash)
          (hasheq)
          (hasheqv)
          (make-weak-hash)
          (make-weak-hasheq)
          (make-weak-hasheqv)
          (make-immutable-hash)
          (make-immutable-hasheq)
          (make-immutable-hasheqv)

          (box "x")
          (void)
          undefined
          #rx".*" #px"3?" #rx#"t.m" #px#".i."
          (in-vector #(1 2 3)) (stream 1 2 3)
          #hash((a . "apple")) #("apple" "binana") '("apple" "binana")
           '((a . "apple") (b . "binana"))
           (set 1 2 3) (seteq 1 2 3) (seteqv 1 2 3)
           (mutable-set 1 2 3) (mutable-seteq 1 2 3) (mutable-seteqv 1 2 3)
           (weak-set 1 2 3) (weak-seteq 1 2 3) (weak-seteqv 1 2 3)

           + (λ (x) #t) (call/cc (λ (k) k))

           (new object%) (new foo%)

           #'(xxy zzy)
           (my-tree (my-tree #f 1 #f) 2 #f)
           (with-handlers ((exn? values)) (error 'aargh!))
           (with-handlers ((exn? values))
             (file->string "/tmp/there-is-no-way-this-file-exists---surely?"))
           (delay 3)
          ))

  ;; tempted to print a cross-reference table, but that would be too wide for RC (maybe)
  (write-xexpr #:insert-newlines? #f
   `(table (thead (tr (th "Value [~s]") (th "->type-name")))
           "\n"
           (tbody ,@(map (λ (v) `(tr "\n" (td ,(~s v))
                                     (td ,(string-join (->type-names v) ", "))))
                         test-values)))))
