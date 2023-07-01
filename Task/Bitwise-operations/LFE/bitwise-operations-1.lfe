(defun bitwise (a b)
  (lists:map
    (lambda (x) (io:format "~p~n" `(,x)))
    `(,(band a b)
      ,(bor a b)
      ,(bxor a b)
      ,(bnot a)
      ,(bsl a b)
      ,(bsr a b)))
  'ok)

(defun dec->bin (x)
  (integer_to_list x 2))

(defun describe (func arg1 arg2 result)
  (io:format "(~s ~s ~s): ~s~n"
             (list func (dec->bin arg1) (dec->bin arg2) (dec->bin result))))

(defun bitwise
  ((a b 'binary)
    (describe "band" a b (band a b))
    (describe "bor" a b (bor a b))
    (describe "bxor" a b (bxor a b))
    (describe "bnot" a b (bnot a))
    (describe "bsl" a b (bsl a b))
    (describe "bsr" a b (bsr a b))))
