(defparameter *table-A* '((27 "Jonah") (18 "Alan") (28 "Glory") (18 "Popeye") (28 "Alan")))

(defparameter *table-B* '(("Jonah" "Whales") ("Jonah" "Spiders") ("Alan" "Ghosts") ("Alan" "Zombies") ("Glory" "Buffy")))

;; Hash phase
(defparameter *hash-table* (make-hash-table :test #'equal))

(loop for (i r) in *table-A*
   for value = (gethash r *hash-table* (list nil))  do
   (setf (gethash r *hash-table*) value)
   (push (list i r) (first value)))

;; Join phase
(loop for (i r) in *table-B* do
     (let ((val (car (gethash i *hash-table*))))
       (loop for (a b) in val do
	    (format t "{~a ~a} {~a ~a}~%"  a b i r))))
