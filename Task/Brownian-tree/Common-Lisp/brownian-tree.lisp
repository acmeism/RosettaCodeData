;;; brownian.lisp
;;; sbcl compile: first load and then (sb-ext:save-lisp-and-die "brownian" :executable t :toplevel #'brownian::main)
(ql:quickload "cl-gd")

(defpackage #:brownian
  (:use #:cl #:cl-gd))
(in-package #:brownian)

(defvar *size* 512)
(defparameter bitmap (make-array *size*))
(dotimes (i *size*)
  (setf (svref bitmap i) (make-array *size* :element-type 'bit)))

;;; is pixel at coord set? returns coord if so otherwise nil if not set or invalid
;;; type:pair->pair|nil
(defun set-p (coord)
  (and coord (= (sbit (svref bitmap (car coord)) (cdr coord)) 1) coord))

;;; valid coord predicate, return its arg if valid or nil otherwise
;;; type:pair->pair|nil
(defun coord-p (coord)
  (and ((lambda (v hi) (and (>= v 0) (< v hi))) (car coord) *size*)
       ((lambda (v hi) (and (>= v 0) (< v hi))) (cdr coord) *size*)
       coord))

;;; valid coord predicate for the ith neighbour, return its arg if valid or nil otherwise
;;; type:pair->pair|nil
(defun coordi-p (coord i)
  (coord-p (cons (+ (car coord) (nth i '(-1 -1 -1 0 0 1 1 1)))
                 (+ (cdr coord) (nth i '(-1 0 1 -1 1 -1 0 1))))))

;;; random walk until out of bounds or hit occupied pixel
;;; assumes start is valid vacant coord, return start or nil if off-grid
;;; type:pair->pair|nil
(defun random-walk (start)
  (let ((next (coordi-p start (random 8))))
    (if (set-p next) start
        (and next (random-walk next)))))

;;; random walk until out of bounds or or adjacent to occupied pixel
;;; assumes start is valid vacant coord, return start or nil if off-grid
;;; type:pair->pair|nil
(defun random-walk2 (start)
  (if (some #'set-p
            (remove-if #'null (mapcar (lambda (i) (coordi-p start i)) '(0 1 2 3 4 5 6 7))))
      start
      (let ((next (coordi-p start (random 8))))
        (and next (random-walk2 next)))))


(defparameter use-walk2 nil)
(defun main ()
  (setf *random-state* (make-random-state t)) ;; randomize
  (when (cdr sb-ext:*posix-argv*) (setf use-walk2 t)) ;; any cmd line arg -> use alt walk algorithm
  (with-image* (*size* *size*)
    (allocate-color 0 0 0) ; background color

    ;;; set the desired number of pixels in image as a pct (10%) of total
    (let ((target (truncate (* 0.10 (* *size* *size*))))
          (green (allocate-color 104 156 84)))

      (defun write-pixel (coord)
        (set-pixel (car coord) (cdr coord) :color green)
        (setf (sbit (svref bitmap (car coord)) (cdr coord)) 1)
        coord)

      ;; initial point set
      (write-pixel (cons (truncate (/ *size* 2)) (truncate (/ *size* 2))))

      ;; iterate until target # of pixels are set
      (do ((i 0 i)
           (seed (cons (random *size*) (random *size*))  (cons (random *size*) (random *size*))))
          ((= i target) )

        (let ((newcoord (and (not (set-p seed)) (if use-walk2 (random-walk2 seed) (random-walk seed)))))
          (when newcoord
            (write-pixel newcoord)
            (incf i)

            ;; report every 5% of progress
            (when (zerop (rem i (round (* target 0.05))))
              (format t "~A% done.~%" (round (/ i target 0.01))))))))

    (write-image-to-file "brownian.png"
                         :compression-level 6 :if-exists :supersede)))
