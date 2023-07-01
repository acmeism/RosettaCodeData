;;;
;;;   This is a straight port of the Erlang version.
;;;
;;;   You can run this under the LFE REPL as follows:
;;;
;;;   (slurp "concurrent-computing.lfe")
;;;   (start)
;;;
(defmodule concurrent-computing
  (export (start 0)))

(defun start ()
  (lc ((<- word '("Enjoy" "Rosetta" "Code")))
    (spawn (lambda () (say (self) word))))
  (wait 2)
  'ok)

(defun say (pid word)
  (lfe_io:format "~p~n" (list word))
  (! pid 'done))

(defun wait (n)
  (receive
    ('done (case n
             (0 0)
             (_n (wait (- n 1)))))))
