(defun bitwise (a b)
    (io:format '"~p~n" (list (band a b)))
    (io:format '"~p~n" (list (bor a b)))
    (io:format '"~p~n" (list (bxor a b)))
    (io:format '"~p~n" (list (bnot a)))
    (io:format '"~p~n" (list (bsl a b)))
    (io:format '"~p~n" (list (bsr a b))))

(defun d2b
  (x) (integer_to_list x 2))

(defun bitwise
  ((a b 'binary)
    (io:format '"(~s ~s ~s): ~s~n"
               (list "band" (d2b a) (d2b b) (d2b (band a b))))
    (io:format '"(~s ~s ~s): ~s~n"
               (list "bor" (d2b a) (d2b b) (d2b (bor a b))))
    (io:format '"(~s ~s ~s): ~s~n"
               (list "bxor" (d2b a) (d2b b) (d2b (bxor a b))))
    (io:format '"(~s ~s): ~s~n"
               (list "bnot" (d2b a) (d2b (bnot a))))
    (io:format '"(~s ~s ~s): ~s~n"
               (list "bsl" (d2b a) (d2b b) (d2b (bsl a b))))
    (io:format '"(~s ~s ~s): ~s~n"
               (list "bsr" (d2b a) (d2b b) (d2b (bsr a b))))))
