(defmodule arith
  (export all))

(defun demo-arith ()
  (case (: io fread '"Please enter two integers: " '"~d~d")
    ((tuple 'ok (a b))
      (: io format '"~p + ~p = ~p~n" (list a b (+ a b)))
      (: io format '"~p - ~p = ~p~n" (list a b (- a b)))
      (: io format '"~p * ~p = ~p~n" (list a b (* a b)))
      (: io format '"~p^~p = ~p~n" (list a b (: math pow a b)))
      ; div truncates towards zero
      (: io format '"~p div ~p = ~p~n" (list a b (div a b)))
      ; rem's result takes the same sign as the first operand
      (: io format '"~p rem ~p = ~p~n" (list a b (rem a b))))))
