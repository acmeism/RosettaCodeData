(defun next-row (row)
   (cons 1
      (cl:maplist
         (match-lambda
            (((list a)) a)
            (((cons a (cons b _))) (+ a b)))
         row)))

(defun pascal (n)
   (pascal n '(())))

(defun pascal
   ((0 rows) (cdr (lists:reverse rows)))
   ((n (= (cons row _) rows))
      (pascal (- n 1) (cons (next-row row) rows))))

(defun show-x
   ((0) "")
   ((1) "x")
   ((n) (++ "x^" (integer_to_list n))))

(defun rhs
   (('() _ _) "")
   (((cons coef coefs) sgn exp)
      (++
         (if (< sgn 0) " - " " + ")
         (integer_to_list coef)
         (show-x exp)
         (rhs coefs (- sgn) (- exp 1)))))

(defun binomial-text (row)
   (let ((degree (- (length row) 1)))
      (++ "(x - 1)^" (integer_to_list degree) " =" (rhs row 1 degree))))

(defun primerow
   (('() _)
      'true)
   ((`(1 . ,rest) n)
      (primerow rest n))
   (((cons a (cons a _)) n) ; stop when we've checked half the list
      (=:= 0 (rem a n)))
   (((cons a rest) n)
      (andalso
         (=:= 0 (rem a n))
         (primerow rest n))))

(defun main (_)
   (list-comp
      ((<- row (pascal 8)))
      (lfe_io:format "~s~n" (list (binomial-text row))))

   (lfe_io:format "~nThe primes upto 50: ~p~n"
      (list
         (list-comp
            ((<- (tuple row n) (lists:zip (cddr (pascal 51)) (lists:seq 2 50)))
             (primerow row n))
            n))))
