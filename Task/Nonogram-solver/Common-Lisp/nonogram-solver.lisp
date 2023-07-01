(defpackage :ac3
  (:use :cl)
  (:export :var
           :domain
           :satisfies-p
           :constraint-possible-p
           :ac3)
  (:documentation "Implements the AC3 algorithm. Extend VAR with the variable
types for your particular problem and implement SATISFIES-P and
CONSTRAINT-POSSIBLE-P for your variables. Initialize the DOMAIN of your variables
with unary constraints already satisfied and then pass them to AC3 in a list."))

(in-package :ac3)

(defclass var ()
  ((domain :initarg :domain :accessor domain))
  (:documentation "The base variable type from which all other
variables should extend."))

(defgeneric satisfies-p (a b va vb)
  (:documentation "Determine if constrainted variables A and B are
satisfied by the instantiation of their respective values VA and VB."))

(defgeneric constraint-possible-p (a b)
  (:documentation "Determine if variables A and B can even be
checked for a binary constraint."))

(defun arc-reduce (a b)
  "Assuming A and B truly form a constraint, prune all values
from A that do not satisfy any value in B. Return T if the domain
of A changed by any amount, NIL otherwise."
  (let (change)
    (setf (domain a)
          (loop for va in (domain a)
             when (loop for vb in (domain b)
                     do (when (satisfies-p a b va vb)
                          (return t))
                     finally (setf change t) (return nil))
             collect va))
    change))

(defun binary-constraint-p (a b)
  "Check if variables A and B could form a constraint, then return T
if any of their values form a contradiction, NIL otherwise."
  (when (constraint-possible-p a b)
    (block found
      (loop for va in (domain a)
         do (loop for vb in (domain b)
               do (unless (satisfies-p a b va vb)
                    (return-from found t)))))))

(defun ac3 (vars)
  "Run the Arc Consistency 3 algorithm on the given set of variables.
Assumes unary constraints have already been satisfied."
  ;; Form a worklist of the constraints of every variable to every other variable.
  (let ((worklist (loop for x in vars
                     append (loop for y in vars
                               when (and (not (eq x y))
                                         (binary-constraint-p x y))
                               collect (cons x y)))))
    ;; Prune the worklist of satisfied arcs until it is empty.
    (loop while worklist
       do (destructuring-bind (x . y) (pop worklist)
            (when (arc-reduce x y)
              (if (domain x)
                  ;; If the current arc's domain was reduced, then append any arcs it
                  ;; is still constrained with to the end of the worklist, as they
                  ;; need to be rechecked.
                  (setf worklist (nconc worklist (loop for z in vars
                                                    when (and (not (eq x z))
                                                              (not (eq y z))
                                                              (binary-constraint-p x z))
                                                    collect (cons z x))))
                  (error "No values left in ~a" x))))
       finally (return vars))))

(defpackage :nonogram
  (:use :cl :ac3)
  (:documentation "Utilize the AC3 package to solve nonograms."))

(in-package :nonogram)

(defclass line (var)
  ((depth :initarg :depth :accessor depth))
  (:documentation "A LINE is a variable that represents either a
column or row of cells and all of the permutations of values those
cells can assume"))

(defmethod print-object ((o line) s)
  (print-unreadable-object (o s :type t)
    (with-slots (depth domain) o
      (format s ":depth ~a :domain ~a" depth domain))))

(defclass row (line) ())

(defclass col (line) ())

(defmethod satisfies-p ((a line) (b line) va vb)
  (eq (aref va (depth b))
      (aref vb (depth a))))

(defmethod constraint-possible-p ((a line) (b line))
  (not (eq (type-of a) (type-of b))))

(defun make-line-domain (runs length &optional (start 0) acc)
  "Enumerate all valid permutations of a line's values."
  (if runs
      (loop for i from start
         to (- length
               (reduce #'+ (cdr runs))
               (length (cdr runs))
               (car runs))
         append (make-line-domain (cdr runs) length (+ 1 i (car runs)) (cons i acc)))
      (list (reverse acc))))

(defun make-line (type runs depth length)
  "Create and initialize a ROW or COL instance."
  (make-instance
   type :depth depth :domain
   (loop for value in (make-line-domain runs length)
      collect (let ((arr (make-array length :initial-element nil)))
                (loop for pos in value
                   for run in runs
                   do (loop for i from pos below (+ pos run)
                         do (setf (aref arr i) t)))
                arr))))

(defun make-lines (type run-set length)
  "Initialize a set of lines."
  (loop for runs across run-set
     for depth from 0
     collect (make-line type runs depth length)))

(defun nonogram (problem)
  "Given a nonogram problem description, solve it and print the result."
  (let* ((nrows (length (aref problem 0)))
         (ncols (length (aref problem 1)))
         (vars (ac3 (append (make-lines 'row (aref problem 0) ncols)
                            (make-lines 'col (aref problem 1) nrows)))))
    (loop for var in vars
       while (eq 'row (type-of var))
       do (terpri)
         (loop for cell across (car (domain var))
            do (format t "~a " (if cell #\# #\.))))))

(defparameter *test-set*
  '("C BA CB BB F AE F A B"
    "AB CA AE GA E C D C"))

;; Helper functions to read and parse problems from a file.

(defun parse-word (word)
  (map 'list (lambda (c) (- (digit-char-p c 36) 9)) word))

(defun parse-line (line)
  (map 'vector #'parse-word (uiop:split-string (string-upcase line))))

(defun parse-nonogram (rows columns)
  (vector (parse-line rows)
          (parse-line columns)))

(defun read-until-line (stream)
  (loop (let ((line (read-line stream)))
          (when (> (length (string-trim '(#\space) line)) 0)
            (print line)
            (return line)))))

(defun solve-from-file (file)
  (handler-case
      (with-open-file (s file)
        (loop
           (terpri)
           (nonogram (parse-nonogram (read-until-line s)
                                     (read-until-line s)))))
    (end-of-file ())))
