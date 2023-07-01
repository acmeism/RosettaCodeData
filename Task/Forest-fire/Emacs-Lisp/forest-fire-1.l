#!/usr/bin/env emacs -script
;; -*- lexical-binding: t -*-
;; run: ./forest-fire forest-fire.config
(require 'cl-lib)
;; (setq debug-on-error t)

(defmacro swap (a b)
  `(setq ,b (prog1 ,a (setq ,a ,b))))

(defconst burning ?B)
(defconst tree ?t)

(cl-defstruct world rows cols data)

(defun new-world (rows cols)
  ;; When allocating the vector add padding so the border will always be empty.
  (make-world :rows rows :cols cols :data (make-vector (* (1+ rows) (1+ cols)) nil)))

(defmacro world--rows (w)
  `(1+ (world-rows ,w)))

(defmacro world--cols (w)
  `(1+ (world-cols ,w)))

(defmacro world-pt (w r c)
  `(+ (* (mod ,r (world--rows ,w)) (world--cols ,w))
      (mod ,c (world--cols ,w))))

(defmacro world-ref (w r c)
  `(aref (world-data ,w) (world-pt ,w ,r ,c)))

(defun print-world (world)
  (dotimes (r (world-rows world))
    (dotimes (c (world-cols world))
      (let ((cell (world-ref world r c)))
        (princ (format "%c" (if (not (null cell))
                   cell
                 ?.)))))
    (terpri)))

(defun random-probability ()
  (/ (float (random 1000000)) 1000000))

(defun initialize-world (world p)
  (dotimes (r (world-rows world))
    (dotimes (c (world-cols world))
      (setf (world-ref world r c) (if (<= (random-probability) p) tree nil)))))

(defun neighbors-burning (world row col)
  (let ((n 0))
    (dolist (offset '((1 . 1) (1 . 0) (1 . -1) (0 . 1) (0 . -1) (-1 . 1) (-1 . 0) (-1 . -1)))
      (when (eq (world-ref world (+ row (car offset)) (+ col (cdr offset))) burning)
        (setq n (1+ n))))
    (> n 0)))

(defun advance (old new p f)
  (dotimes (r (world-rows old))
    (dotimes (c (world-cols old))
      (cond
       ((eq (world-ref old r c) burning)
        (setf (world-ref new r c) nil))
       ((null (world-ref old r c))
        (setf (world-ref new r c) (if (<= (random-probability) p) tree nil)))
       ((eq (world-ref old r c) tree)
        (setf (world-ref new r c) (if (or (neighbors-burning old r c)
                                          (<= (random-probability) f))
                                      burning
                                    tree)))))))

(defun read-config (file-name)
  (with-temp-buffer
    (insert-file-contents-literally file-name)
    (read (current-buffer))))

(defun get-config (key config)
  (let ((val (assoc key config)))
    (if (null val)
        (error (format "missing value for %s" key))
      (cdr val))))

(defun simulate-forest (file-name)
  (let* ((config (read-config file-name))
         (rows (get-config 'rows config))
         (cols (get-config 'cols config))
         (skip (get-config 'skip config))
         (a (new-world rows cols))
         (b (new-world rows cols)))
    (initialize-world a (get-config 'tree config))
    (dotimes (time (get-config 'time config))
      (when (or (and (> skip 0) (= (mod time skip) 0))
                (<= skip 0))
        (princ (format "* time %d\n" time))
        (print-world a))
      (advance a b (get-config 'p config) (get-config 'f config))
      (swap a b))))

(simulate-forest (elt command-line-args-left 0))
