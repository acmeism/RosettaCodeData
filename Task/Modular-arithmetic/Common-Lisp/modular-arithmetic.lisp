(defvar *modulus* nil)

(defmacro define-enhanced-op (enhanced-op op)
  `(defun ,enhanced-op (&rest args)
     (if *modulus*
         (mod (apply ,op args) *modulus*)
         (apply ,op args))))

(define-enhanced-op enhanced+ #'+)
(define-enhanced-op enhanced-expt #'expt)

(defun f (x)
  (enhanced+ (enhanced-expt x 100) x 1))

;; Use f on regular integers.
(princ "No modulus:  ")
(princ (f 10))
(terpri)

;; Use f on modular integers.
(let ((*modulus* 13))
  (princ "modulus 13:  ")
  (princ (f 10))
  (terpri))
