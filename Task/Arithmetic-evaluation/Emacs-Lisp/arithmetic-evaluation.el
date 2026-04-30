#!/usr/bin/env emacs --script
;; -*- mode: emacs-lisp; lexical-binding: t -*-
;;> ./arithmetic-evaluation '(1 + 2) * 3'

(defun advance ()
  (let ((rtn (buffer-substring-no-properties (point) (match-end 0))))
    (goto-char (match-end 0))
    rtn))

(defvar current-symbol nil)

(defun next-symbol ()
  (when (looking-at "[ \t\n]+")
    (goto-char (match-end 0)))

  (cond
   ((eobp)
    (setq current-symbol 'eof))
   ((looking-at "[0-9]+")
    (setq current-symbol (string-to-number (advance))))
   ((looking-at "[-+*/()]")
    (setq current-symbol (advance)))
   ((looking-at ".")
    (error "Unknown character '%s'" (advance)))))

(defun accept (sym)
  (when (equal sym current-symbol)
    (next-symbol)
    t))

(defun expect (sym)
  (unless (accept sym)
    (error "Expected symbol %s, but found %s" sym current-symbol))
  t)

(defun p-expression ()
  " expression = term  { ('+' | '-') term } . "
  (let ((rtn (p-term)))
    (while (or (equal current-symbol "+") (equal current-symbol "-"))
      (let ((op current-symbol)
            (left rtn))
        (next-symbol)
        (setq rtn (list op left (p-term)))))
    rtn))

(defun p-term ()
  " term = factor  { ('*' | '/') factor } . "
  (let ((rtn (p-factor)))
    (while (or (equal current-symbol "*") (equal current-symbol "/"))
      (let ((op current-symbol)
            (left rtn))
        (next-symbol)
        (setq rtn (list op left (p-factor)))))
    rtn))

(defun p-factor ()
  " factor = constant | variable | '('  expression  ')' . "
  (let (rtn)
    (cond
     ((numberp current-symbol)
      (setq rtn current-symbol)
      (next-symbol))
     ((accept "(")
      (setq rtn (p-expression))
      (expect ")"))
     (t (error "Syntax error")))
    rtn))

(defun ast-build (expression)
  (let (rtn)
    (with-temp-buffer
      (insert expression)
      (goto-char (point-min))
      (next-symbol)
      (setq rtn (p-expression))
      (expect 'eof))
    rtn))

(defun ast-eval (v)
  (pcase v
    ((pred numberp) v)
    (`("+" ,a ,b) (+ (ast-eval a) (ast-eval b)))
    (`("-" ,a ,b) (- (ast-eval a) (ast-eval b)))
    (`("*" ,a ,b) (* (ast-eval a) (ast-eval b)))
    (`("/" ,a ,b) (/ (ast-eval a) (float (ast-eval b))))
    (_ (error "Unknown value %s" v))))

(dolist (arg command-line-args-left)
  (let ((ast (ast-build arg)))
    (princ (format "       ast = %s\n" ast))
    (princ (format "     value = %s\n" (ast-eval ast)))
    (terpri)))
(setq command-line-args-left nil)
