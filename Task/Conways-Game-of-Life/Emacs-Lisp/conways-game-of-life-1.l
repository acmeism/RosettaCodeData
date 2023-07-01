#!/usr/bin/env emacs -script
;; -*- lexical-binding: t -*-
;; run: ./conways-life conways-life.config
(require 'cl-lib)

(defconst blinker '("***"))
(defconst toad '(".***" "***."))
(defconst pentomino-p '(".**" ".**" ".*."))
(defconst pi-heptomino '("***" "*.*" "*.*"))
(defconst glider '(".*." "..*" "***"))
(defconst pre-pulsar '("***...***" "*.*...*.*" "***...***"))
(defconst ship '("**." "*.*" ".**"))
(defconst pentadecathalon '("**********"))
(defconst clock '("..*." "*.*." ".*.*" ".*.."))

(defmacro swap (a b)
  `(setq ,b (prog1 ,a (setq ,a ,b))))

(cl-defstruct world rows cols data)

(defun new-world (rows cols)
  (make-world :rows rows :cols cols :data (make-vector (* rows cols) nil)))

(defmacro world-pt (w r c)
  `(+ (* (mod ,r (world-rows ,w)) (world-cols ,w))
      (mod ,c (world-cols ,w))))

(defmacro world-ref (w r c)
  `(aref (world-data ,w) (world-pt ,w ,r ,c)))

(defun print-world (world)
  (dotimes (r (world-rows world))
    (dotimes (c (world-cols world))
      (princ (format "%c" (if (world-ref world r c) ?* ?.))))
    (terpri)))

(defun insert-pattern (world row col shape)
  (let ((r row)
        (c col))
    (unless (listp shape)
      (setq shape (symbol-value shape)))
    (dolist (row-data shape)
      (dolist (col-data (mapcar 'identity row-data))
        (setf (world-ref world r c) (not (or (eq col-data ?.))))
        (setq c (1+ c)))
      (setq r (1+ r))
      (setq c col))))

(defun neighbors (world row col)
  (let ((n 0))
    (dolist (offset '((1 . 1) (1 . 0) (1 . -1) (0 . 1) (0 . -1) (-1 . 1) (-1 . 0) (-1 . -1)))
      (when (world-ref world (+ row (car offset)) (+ col (cdr offset)))
        (setq n (1+ n))))
    n))

(defun advance-generation (old new)
  (dotimes (r (world-rows old))
    (dotimes (c (world-cols old))
      (let ((n (neighbors old r c)))
        (setf (world-ref new r c)
              (if (world-ref old r c)
                  (or (= n 2) (= n 3))
                (= n 3)))))))

(defun read-config (file-name)
  (with-temp-buffer
    (insert-file-contents-literally file-name)
    (read (current-buffer))))

(defun get-config (key config)
  (let ((val (assoc key config)))
    (if (null val)
        (error (format "missing value for %s" key))
      (cdr val))))

(defun insert-patterns (world patterns)
  (dolist (p patterns)
    (apply 'insert-pattern (cons world p))))

(defun simulate-life (file-name)
  (let* ((config (read-config file-name))
         (rows (get-config 'rows config))
         (cols (get-config 'cols config))
         (generations (get-config 'generations config))
         (a (new-world rows cols))
         (b (new-world rows cols)))
    (insert-patterns a (get-config 'patterns config))
    (dotimes (g generations)
      (princ (format "generation %d\n" g))
      (print-world a)
      (advance-generation a b)
      (swap a b))))

(simulate-life (elt command-line-args-left 0))
