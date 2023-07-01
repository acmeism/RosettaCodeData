;; default :test is #'eql, which is suitable for numbers only,
;; or for implementation identity for other types!
;; Use #'equalp if you want case-insensitive keying on strings.

(setf my-hash (make-hash-table :test #'equal))
(setf (gethash "H2O" my-hash) "Water")
(setf (gethash "HCl" my-hash) "Hydrochloric Acid")
(setf (gethash "CO" my-hash) "Carbon Monoxide")

;; That was actually a hash table, an associative array or
;; alist is written like this:
(defparameter *legs* '((cow . 4) (flamingo . 2) (centipede . 100)))
;; you can use assoc to do lookups and cons new elements onto it to make it longer.
