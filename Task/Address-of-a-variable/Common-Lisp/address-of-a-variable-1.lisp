;;; Demonstration of references by swapping two variables using a function rather than a macro
;;; Needs http://paste.lisp.org/display/71952
(defun swap (ref-left ref-right)
  ;; without with-refs we would have to write this:
  ;; (psetf (deref ref-left) (deref ref-right)
  ;;        (deref ref-right) (deref ref-left))
  (with-refs ((l ref-left) (r ref-right))
    (psetf l r r l)))

(defvar *x* 42)
(defvar *y* 0)

(swap (ref *x*) (ref *y*))

;; *y* -> 42
;; *x* -> 0
