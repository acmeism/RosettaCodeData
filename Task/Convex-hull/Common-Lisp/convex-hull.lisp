#!/bin/sh
#|-*- mode:lisp -*-|#
#|
exec ros -Q -- $0 "$@"
|#
(progn ;;init forms
  (ros:ensure-asdf)
  #+quicklisp(ql:quickload '() :silent t)
  )

(defpackage :ros.script.convex-hull-task.3861520611
  (:use :cl))
(in-package :ros.script.convex-hull-task.3861520611)

;;;
;;; Convex hulls by Andrew's monotone chain algorithm.
;;;
;;; For a description of the algorithm, see
;;; https://en.wikibooks.org/w/index.php?title=Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain&stableid=40169
;;;
;;; This program is translated rather faithfully from the Scheme,
;;; complete with tail recursions.
;;;

;; x and y coordinates of a "point". A "point" is represented by a
;; list of length 2.
(defun x@ (u) (car u))
(defun y@ (u) (cadr u))

(defun cross (u v)
  ;; Cross product (as a signed scalar).
  (- (* (x@ u) (y@ v)) (* (y@ u) (x@ v))))

(defun point- (u v)
  (list (- (x@ u) (x@ v)) (- (y@ u) (y@ v))))

(defun sort-points-vector (points-vector)
  ;; Ascending sort on x-coordinates, followed by ascending sort
  ;; on y-coordinates.
  (sort points-vector #'(lambda (u v)
                          (or (< (x@ u) (x@ v))
                              (and (= (x@ u) (x@ v))
                                   (< (y@ u) (y@ v)))))))

(defun construct-lower-hull (sorted-points-vector)
  (let* ((pt sorted-points-vector)
         (n (length pt))
         (hull (make-array n))
         (j 1))
    (setf (aref hull 0) (aref pt 0))
    (setf (aref hull 1) (aref pt 1))
    (loop for i from 2 to (1- n)
          do (progn
               (defun inner-loop ()
                 (if (or (zerop j)
                         (plusp
                          (cross (point- (aref hull j)
                                         (aref hull (1- j)))
                                 (point- (aref pt i)
                                         (aref hull (1- j))))))
                     (progn
                       (setf j (1+ j))
                       (setf (aref hull j) (aref pt i)))
                     (progn
                       (setf j (1- j))
                       (inner-loop))))
               (inner-loop)))
    (values (+ j 1) hull)))             ; Hull size, hull points.

(defun construct-upper-hull (sorted-points-vector)
  (let* ((pt sorted-points-vector)
         (n (length pt))
         (hull (make-array n))
         (j 1))
    (setf (aref hull 0) (aref pt (- n 1)))
    (setf (aref hull 1) (aref pt (- n 2)))
    (loop for i from (- n 3) downto 0
          do (progn
               (defun inner-loop ()
                 (if (or (zerop j)
                         (plusp
                          (cross (point- (aref hull j)
                                         (aref hull (1- j)))
                                 (point- (aref pt i)
                                         (aref hull (1- j))))))
                     (progn
                       (setf j (1+ j))
                       (setf (aref hull j) (aref pt i)))
                     (progn
                       (setf j (1- j))
                       (inner-loop))))
               (inner-loop)))
    (values (+ j 1) hull)))             ; Hull size, hull points.

(defun construct-hull (sorted-points-vector)
  ;; Notice that the lower and upper hulls could be constructed in
  ;; parallel. (The Scheme "let-values" macro made this apparent,
  ;; despite not actually doing the computation in parallel. The
  ;; coding here makes it less obvious.)
  (multiple-value-bind (lower-hull-size lower-hull)
      (construct-lower-hull sorted-points-vector)
    (multiple-value-bind (upper-hull-size upper-hull)
        (construct-upper-hull sorted-points-vector)
      (let* ((hull-size (+ lower-hull-size upper-hull-size -2))
             (hull (make-array hull-size)))
        (loop for i from 0 to (- lower-hull-size 2)
              do (setf (aref hull i) (aref lower-hull i)))
        (loop for i from 0 to (- upper-hull-size 2)
              do (setf (aref hull (+ i (1- lower-hull-size)))
                       (aref upper-hull i)))
        hull))))

(defun vector-delete-neighbor-dups (elt= v)
  ;; A partial clone of the SRFI-132 procedure of the same name. This
  ;; implementation is similar to the reference implementation for
  ;; SRFI-132, and may use a bunch of stack space.  That reference
  ;; implementation is by Olin Shivers and rests here:
  ;; https://github.com/scheme-requests-for-implementation/srfi-132/blob/master/sorting/delndups.scm
  ;; The license is:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This code is
;;;     Copyright (c) 1998 by Olin Shivers.
;;; The terms are: You may do as you please with this code, as long as
;;; you do not delete this notice or hold me responsible for any outcome
;;; related to its use.
;;;
;;; Blah blah blah. Don't you think source files should contain more lines
;;; of code than copyright notice?
;;;
  (let ((start 0)
        (end (length v)))
    (let ((x (aref v start)))
      (defun recur (x i j)
        (if (< i end)
            (let ((y (aref v i))
                  (nexti (1+ i)))
              (if (funcall elt= x y)
                  (recur x nexti j)
                  (let ((ansvec (recur y nexti (1+ j))))
                    (setf (aref ansvec j) y)
                    ansvec)))
            (make-array j)))
      (let ((ans (recur x start 1)))
        (setf (aref ans 0) x)
        ans))))

(defun vector-convex-hull (points)
  (let* ((points-vector (coerce points 'vector))
         (sorted-points-vector
           (vector-delete-neighbor-dups
            #'equalp
            (sort-points-vector points-vector))))
    (if (<= (length sorted-points-vector) 2)
        sorted-points-vector
        (construct-hull sorted-points-vector))))

(defun list-convex-hull (points)
  (coerce (vector-convex-hull points) 'list))

(defconstant example-points
  '((16 3) (12 17) (0 6) (-4 -6) (16 6)
    (16 -7) (16 -3) (17 -4) (5 19) (19 -8)
    (3 16) (12 13) (3 -4) (17 5) (-3 15)
    (-3 -9) (0 11) (-9 -3) (-4 -2) (12 10)))

(defun main (&rest argv)
  (declare (ignorable argv))
  (write (list-convex-hull example-points))
  (terpri))

;;; vim: set ft=lisp lisp:
