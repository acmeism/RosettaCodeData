;; The -> notation is not part of Lisp, it is used in examples indicate the output of a form.
;;
;;
(comprehend 'list-monad (cons x y) (x '(1 2 3)) (y '(A B C)))

     -> ((1 . A) (1 . B) (1 . C)
         (2 . A) (2 . B) (2 . C)
         (3 . A) (3 . B) (3 . C))
