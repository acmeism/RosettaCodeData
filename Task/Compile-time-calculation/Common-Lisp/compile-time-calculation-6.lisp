(define-compiler-macro factorial (&whole form arg)
  (if (constantp arg)
    (factorial arg)
    form))
