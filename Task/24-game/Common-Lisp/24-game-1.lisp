(define-condition choose-digits () ())
(define-condition bad-equation (error) ())

(defun 24-game ()
  (let (chosen-digits)
    (labels ((prompt ()
               (format t "Chosen digits: ~{~D~^, ~}~%~
                          Enter expression (or `bye' to quit, `!' to choose new digits): "
                       chosen-digits)
               (read))
             (lose () (error 'bad-equation))
             (choose () (setf chosen-digits (loop repeat 4 collecting (random 10))))
             (check (e)
               (typecase e
                 ((eql bye) (return-from 24-game))
                 ((eql !) (signal 'choose-digits))
                 (atom (lose))
                 (cons (check-sub (car e) (check-sub (cdr e) chosen-digits)) e)))
             (check-sub (sub allowed-digits)
               (typecase sub
                 ((member nil + - * /) allowed-digits)
                 (integer
                  (if (member sub allowed-digits)
                      (remove sub allowed-digits :count 1)
                      (lose)))
                 (cons (check-sub (car sub) (check-sub (cdr sub) allowed-digits)))
                 (t (lose))))
             (win ()
               (format t "You win.~%")
               (return-from 24-game)))
      (choose)
      (loop
       (handler-case
           (if (= 24 (eval (check (prompt)))) (win) (lose))
         (error () (format t "Bad equation, try again.~%"))
         (choose-digits () (choose)))))))
