(define-syntax define-constant
  (syntax-rules ()
    ((_ id v)
     (begin
       (define _id v)
       (define-syntax id
         (make-variable-transformer
          (lambda (stx)
            (syntax-case stx (set!)
              ((set! id _)
               (raise
                (syntax-violation
                 'set! "Cannot redefine constant" stx #'id)))
              ((id . args) #'(_id . args))
              (id #'_id)))))))))
