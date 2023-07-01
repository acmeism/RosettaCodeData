(defpackage :funky
  ;; only these symbols are public
  (:export :widget :get-wobbliness)
  ;; for convenience, bring common lisp symbols into funky
  (:use :cl))

;; switch reader to funky package: all symbols that are
;; not from the CL package are interned in FUNKY.

(in-package :funky)

(defclass widget ()
  ;; :initarg -> slot "wobbliness" is initialized using :wobbliness keyword
  ;; :initform -> if initarg is missing, slot defaults to 42
  ;; :reader -> a "getter" method called get-wobbliness is generated
  ((wobbliness :initarg :wobbliness :initform 42 :reader get-wobbliness)))

;; simulate being in another source file with its own package:
;; cool package gets external symbols from funky, and cl:
(defpackage :cool
  (:use :funky :cl))

(in-package :cool)

;; we can use the symbol funky:widget without any package prefix:
(defvar *w* (make-instance 'widget :wobbliness 36))

;; ditto with funky:get-wobbliness
(format t "wobbliness: ~a~%" (get-wobbliness *w*))

;; direct access to the slot requires fully qualified private symbol
;; and double colon:
(format t "wobbliness: ~a~%" (slot-value *w* 'funky::wobbliness))

;; if we use unqualified wobbliness, it's a different symbol:
;; it is cool::wobbliness interned in our local package.
;; we do not have funky:wobbliness because it's not exported by funky.
(unless (ignore-errors
          (format t "wobbliness: ~a~%" (slot-value *w* 'wobbliness)))
  (write-line "didn't work"))

;; single colon results in error at read time! The expression is not
;; even read and evaluated. The symbol is internal and so cannot be used.
(format t "wobbliness: ~a~%" (slot-value *w* 'funky:wobbliness))
