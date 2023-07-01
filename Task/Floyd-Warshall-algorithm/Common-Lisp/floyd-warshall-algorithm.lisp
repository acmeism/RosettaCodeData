#!/bin/sh
#|-*- mode:lisp -*-|#
#|
exec ros -Q -- $0 "$@"
|#
(progn ;;init forms
  (ros:ensure-asdf)
  #+quicklisp(ql:quickload '() :silent t)
  )

(defpackage :ros.script.floyd-warshall.3861181636
  (:use :cl))
(in-package :ros.script.floyd-warshall.3861181636)

;;;
;;; Floyd-Warshall algorithm.
;;;
;;; See https://en.wikipedia.org/w/index.php?title=Floyd%E2%80%93Warshall_algorithm&oldid=1082310013
;;;
;;; Translated from the Scheme. Small improvements (or what might be
;;; considered improvements), and some type specialization, have been
;;; added.
;;;

;;;-------------------------------------------------------------------
;;;
;;; A square array will be represented by an ordinary Common Lisp
;;; array, but accessed through our own functions (which look similar
;;; to, although not identical to, the corresponding Scheme
;;; functions).
;;;
;;; Square arrays are indexed *starting at one*.
;;;

(defun make-arr (n &key (element-type t) initial-element)
  (make-array (list n n) :element-type element-type
                         :initial-element initial-element))

(defun arr-set (arr i j x)
  (setf (aref arr (- i 1) (- j 1)) x))

(defun arr-ref (arr i j)
  (aref arr (- i 1) (- j 1)))

;;;-------------------------------------------------------------------
;;;
;;; Floyd-Warshall.
;;;
;;; Input is a list of length-3 lists representing edges; each entry
;;; is:
;;;
;;;    (start-vertex edge-weight end-vertex)
;;;
;;; where vertex identifiers are integers from 1 .. n.
;;;
;;; A difference from the Scheme implementation is that here we do not
;;; assume the floating point supports "infinities". In the Scheme we
;;; did, because in R7RS small there is support for such infinities
;;; (although the standard does not *require* them). Also because
;;; alternatives were not yet apparent to this author. :)
;;;

(defvar *floatpt* 'single-float)
(defconstant nil-vertex 0)

(defun floyd-warshall (edges)
  (let* ((n
           ;; Set n to the maximum vertex number. By design, n also
           ;; equals the number of vertices.
           (max (apply #'max (mapcar #'car edges))
                (apply #'max (mapcar #'caddr edges))))

         (distance
           ;; The distances are initialized to a purely arbitrary
           ;; value. An entry in the "distance" array is meaningful
           ;; *only* if the corresponding entry in "next-vertex" is
           ;; not the nil-vertex.
           (make-arr n :element-type *floatpt*
                       :initial-element (coerce 12345 *floatpt*)))

         (next-vertex
           ;; Unless later set otherwise, an entry in "next-vertex"
           ;; will be the nil-vertex.
           (make-arr n :element-type 'fixnum
                       :initial-element nil-vertex)))

    (defun dist (p q) (arr-ref distance p q))
    (defun next (p q) (arr-ref next-vertex p q))

    (defun set-dist (p q x) (arr-set distance p q x))
    (defun set-next (p q x) (arr-set next-vertex p q x))

    (defun nilnext (p q) (= (next p q) nil-vertex))

    ;; Initialize "distance" and "next-vertex".
    (loop for edge in edges
          do (let ((u (car edge))
                   (weight (cadr edge))
                   (v (caddr edge)))
               (set-dist u v weight)
               (set-next u v v)))
    (loop for v from 1 to n
          do (progn
               ;; The distance from a vertex to itself = 0.0.
               (set-dist v v (coerce 0 *floatpt*))
               (set-next v v v)))

    ;; Perform the algorithm.
    (loop
      for k from 1 to n
      do (loop
           for i from 1 to n
           do (loop
                for j from 1 to n
                do (and (not (nilnext i k))
                        (not (nilnext k j))
                        (let* ((dist-ikj (+ (dist i k) (dist k j))))
                          (when (or (nilnext i j)
                                    (< dist-ikj (dist i j)))
                            (set-dist i j dist-ikj)
                            (set-next i j (next i k))))))))

    ;; Return the results.
    (values n distance next-vertex)))

;;;-------------------------------------------------------------------
;;;
;;; Path reconstruction from the "next-vertex" array.
;;;
;;; The return value is a list of vertices.
;;;

(defun find-path (next-vertex u v)
  (if (= (arr-ref next-vertex u v) nil-vertex)
      (list)
      (cons u (let ((i u))
                (loop while (/= i v)
                      do (setf i (arr-ref next-vertex i v))
                      collect i)))))

;;;-------------------------------------------------------------------

(defun directed-vertex-list-to-string (lst)
  (if (not lst)
      ""
      (let ((s (write-to-string (car lst))))
        (loop for u in (cdr lst)
              do (setf s (concatenate 'string s " -> "
                                      (write-to-string u))))
        s)))

;;;-------------------------------------------------------------------

(defun main (&rest argv)
  (declare (ignorable argv))
  (let ((example-graph
          (mapcar (lambda (x) (list (coerce (car x) 'fixnum)
                                    (coerce (cadr x) *floatpt*)
                                    (coerce (caddr x) 'fixnum)))
                  '((1 -2 3)
                    (3 2 4)
                    (4 -1 2)
                    (2 4 1)
                    (2 3 3)))))
    (multiple-value-bind (n distance next-vertex)
        (floyd-warshall example-graph)
      (princ "  pair    distance   path")
      (terpri)
      (princ "-------------------------------------")
      (terpri)
      (loop
        for u from 1 to n
        do (loop
             for v from 1 to n
             do (unless (= u v)
                  (format
                   t " ~A ~7@A     ~A~%"
                   (directed-vertex-list-to-string (list u v))
                   (if (= (arr-ref next-vertex u v) nil-vertex)
                       "   no path"
                       (write-to-string (arr-ref distance u v)))
                   (directed-vertex-list-to-string
                    (find-path next-vertex u v)))))))))

;;;-------------------------------------------------------------------
;;; vim: set ft=lisp lisp:
