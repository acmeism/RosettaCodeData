;; * Loading the cairo bindings
(eval-when (:compile-toplevel :load-toplevel)
  (ql:quickload '("cl-cairo2" "cl-cairo2-xlib")))

;; * The package definition
(defpackage :sphere
  (:use :common-lisp :cl-cairo2))
(in-package :sphere)

(defparameter *context* nil)
(defparameter *size* 400)
(defparameter *middle* (/ *size* 2))

;; Opening a display and draw a sphere
(let ((width *size*)
      (height *size*))
  ;; Draw to a X-Window
  (setf *context*
        (create-xlib-image-context width height :window-name "Sphere"))
  ;; Clear the whole canvas with gray
  (rectangle 0 0 width height)
  (set-source-rgb 127 127 127)
  (fill-path)
  ;; Draw a the sphere as circa with a radial pattern
  (with-patterns ((pat (create-radial-pattern (* 0.9 *middle*) (* 0.8 *middle*) (* 0.2 *middle*)
                                              (* 0.8 *middle*) (* 0.8 *middle*) *middle*)))
    (pattern-add-color-stop-rgba pat 0 1 1 1 1)
    (pattern-add-color-stop-rgba pat 1 0 0 0 1)
    (set-source pat)
    (arc *middle* *middle* 180 0 (* 2 pi))
    (fill-path))
  ;; Draw to a png file
  (with-png-file ("sphere.png" :rgb24 width height)
    ;; Clear the whole canvas with gray
    (rectangle 0 0 width height)
    (set-source-rgb 127 127 127)
    (fill-path)
    ;; Draw a the sphere as circa with a radial pattern
    (with-patterns ((pat (create-radial-pattern (* 0.9 *middle*) (* 0.8 *middle*) (* 0.2 *middle*)
                                                (* 0.8 *middle*) (* 0.8 *middle*) *middle*)))
      (pattern-add-color-stop-rgba pat 0 1 1 1 1)
      (pattern-add-color-stop-rgba pat 1 0 0 0 1)
      (set-source pat)
      (arc *middle* *middle* 180 0 (* 2 pi))
      (fill-path))))
