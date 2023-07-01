(defmodule args
  (export all))

(defun my-func ()
  (my-func () () ()))

(defun my-func (a)
  (my-func a () ()))

(defun my-func (a b)
  (my-func a b ()))

(defun my-func (a b c)
  (: io format '"~p ~p ~p~n" (list a b c)))
