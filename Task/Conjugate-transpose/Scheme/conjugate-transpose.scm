(import srfi/231)

(define (list*->matrix list*) (list*->array 2 list*))

(define (transpose M) (array-permute M '#(1 0)))

(define (identity M)
  (make-array (array-domain M) (lambda (i j) (if (= i j) 1 0))))

(define (matrix* A B) (array-inner-product A + * B))

(define (^H M) (array-map conjugate (transpose M)))

(define (matrix= A B)
  (and (interval= (array-domain A) (array-domain B))
       (array-every = A B)))

(define (normal? M) (matrix= (matrix* M (^H M)) (matrix* (^H M) M)))

(define (hermitian? M) (matrix= M (^H M)))

(define (unitary? M) (matrix= (matrix* M (^H M)) (identity M)))

(define test-matrices
  (list (list*->matrix '((1  1+i +2i)
                         (1-i  5  -3)
                         (-2i -3   0)))
        (list*->matrix '((1 1 0)
                         (0 1 1)
                         (1 0 1)))
        (list*->matrix '(( 3/5   4/5  0)
                         (+4/5i -3/5i 0)
                         (  0     0  +i)))
        (list*->matrix '((7/9 -4/9 -4/9)
                         (-4/9 1/9 -8/9)
                         (-4/9 -8/9 1/9)))))

(for-each (lambda (M)
            (pretty-print Matrix:)
            (pretty-print (array->list* M))
            (pretty-print Conjugate-transpose:)
            (pretty-print (array->list* (^H M)))
            (for-each display (list "Is Hermitian?\t" (hermitian? M) #\newline))
            (for-each display (list "Is Normal?\t" (normal? M) #\newline))
            (for-each display (list "Is Unitary?\t" (unitary? M) #\newline))
            (newline))
          test-matrices)
