#!/bin/sh
#|-*- mode:lisp -*-|#
#|
exec ros -Q -- $0 "$@"
|#
(progn ;;init forms
  (ros:ensure-asdf)
  #+quicklisp(ql:quickload '() :silent t))

(defpackage :ros.script.parse.3859374047
  (:use :cl))
(in-package :ros.script.parse.3859374047)

;;;
;;; The Rosetta Code Tiny-Language Parser, in Common Lisp.
;;;

(require "cl-ppcre")
(require "trivia")

(defstruct tokstruc line-no column-no tok tokval)

(defconstant re-blank-line
  (ppcre:create-scanner "^\\s*$"))

(defconstant re-token-1
  (ppcre:create-scanner
   "^\\s*(\\d+)\\s+(\\d+)\\s+(\\S+)\\s*$"))

(defconstant re-token-2
  (ppcre:create-scanner
   "^\\s*(\\d+)\\s+(\\d+)\\s+(\\S+)\\s+(\\S(.*\\S)?)\\s*$"))

(defun string-to-tok (s)
  (trivia:match s
    ("Keyword_else" 'TOK-ELSE)
    ("Keyword_if" 'TOK-IF)
    ("Keyword_print" 'TOK-PRINT)
    ("Keyword_putc" 'TOK-PUTC)
    ("Keyword_while" 'TOK-WHILE)
    ("Op_multiply" 'TOK-MULTIPLY)
    ("Op_divide" 'TOK-DIVIDE)
    ("Op_mod" 'TOK-MOD)
    ("Op_add" 'TOK-ADD)
    ("Op_subtract" 'TOK-SUBTRACT)
    ("Op_negate" 'TOK-NEGATE)
    ("Op_less" 'TOK-LESS)
    ("Op_lessequal" 'TOK-LESSEQUAL)
    ("Op_greater" 'TOK-GREATER)
    ("Op_greaterequal" 'TOK-GREATEREQUAL)
    ("Op_equal" 'TOK-EQUAL)
    ("Op_notequal" 'TOK-NOTEQUAL)
    ("Op_not" 'TOK-NOT)
    ("Op_assign" 'TOK-ASSIGN)
    ("Op_and" 'TOK-AND)
    ("Op_or" 'TOK-OR)
    ("LeftParen" 'TOK-LEFTPAREN)
    ("RightParen" 'TOK-RIGHTPAREN)
    ("LeftBrace" 'TOK-LEFTBRACE)
    ("RightBrace" 'TOK-RIGHTBRACE)
    ("Semicolon" 'TOK-SEMICOLON)
    ("Comma" 'TOK-COMMA)
    ("Identifier" 'TOK-IDENTIFIER)
    ("Integer" 'TOK-INTEGER)
    ("String" 'TOK-STRING)
    ("End_of_input" 'TOK-END-OF-INPUT)
    (_ (warn "unparseable token line")
       (uiop:quit 1))))

(defun precedence (tok)
  (case tok
    (TOK-MULTIPLY 13)
    (TOK-DIVIDE 13)
    (TOK-MOD 13)
    (TOK-ADD 12)
    (TOK-SUBTRACT 12)
    (TOK-NEGATE 14)
    (TOK-NOT 14)
    (TOK-LESS 10)
    (TOK-LESSEQUAL 10)
    (TOK-GREATER 10)
    (TOK-GREATEREQUAL 10)
    (TOK-EQUAL 9)
    (TOK-NOTEQUAL 9)
    (TOK-AND 5)
    (TOK-OR 4)
    (otherwise -1)))

(defun binary-p (tok)
  (case tok
    (TOK-ADD t)
    (TOK-SUBTRACT t)
    (TOK-MULTIPLY t)
    (TOK-DIVIDE t)
    (TOK-MOD t)
    (TOK-LESS t)
    (TOK-LESSEQUAL t)
    (TOK-GREATER t)
    (TOK-GREATEREQUAL t)
    (TOK-EQUAL t)
    (TOK-NOTEQUAL t)
    (TOK-AND t)
    (TOK-OR t)
    (otherwise nil)))

(defun right-associative-p (tok)
  (declare (ignorable tok))
  nil)           ; None of the current operators is right associative.

(defun tok-text (tok)
  (ecase tok
    (TOK-ELSE          "else")
    (TOK-IF            "if")
    (TOK-PRINT         "print")
    (TOK-PUTC          "putc")
    (TOK-WHILE         "while")
    (TOK-MULTIPLY      "*")
    (TOK-DIVIDE        "/")
    (TOK-MOD           "%")
    (TOK-ADD           "+")
    (TOK-SUBTRACT      "-")
    (TOK-NEGATE        "-")
    (TOK-LESS          "<")
    (TOK-LESSEQUAL     "<=")
    (TOK-GREATER       ">")
    (TOK-GREATEREQUAL  ">=")
    (TOK-EQUAL         "==")
    (TOK-NOTEQUAL      "!=")
    (TOK-NOT           "!")
    (TOK-ASSIGN        "=")
    (TOK-AND           "&&")
    (TOK-OR            "((")
    (TOK-LEFTPAREN     "(")
    (TOK-RIGHTPAREN    ")")
    (TOK-LEFTBRACE     "{")
    (TOK-RIGHTBRACE    "}")
    (TOK-SEMICOLON     ";")
    (TOK-COMMA         ",")
    (TOK-IDENTIFIER    "Ident")
    (TOK-INTEGER       "Integer literal")
    (TOK-STRING        "String literal")
    (TOK-END_OF_INPUT  "EOI")))

(defun operator (tok)
  (ecase tok
    (TOK-MULTIPLY "Multiply")
    (TOK-DIVIDE "Divide")
    (TOK-MOD "Mod")
    (TOK-ADD "Add")
    (TOK-SUBTRACT "Subtract")
    (TOK-NEGATE "Negate")
    (TOK-NOT "Not")
    (TOK-LESS "Less")
    (TOK-LESSEQUAL "LessEqual")
    (TOK-GREATER "Greater")
    (TOK-GREATEREQUAL "GreaterEqual")
    (TOK-EQUAL "Equal")
    (TOK-NOTEQUAL "NotEqual")
    (TOK-AND "And")
    (TOK-OR "Or")))

(defun join (&rest args)
  (apply #'concatenate 'string args))

(defun nxt (gettok)
  (funcall gettok :nxt))

(defun curr (gettok)
  (funcall gettok :curr))

(defun err (token msg)
  (format t "(~A, ~A) error: ~A~%"
          (tokstruc-line-no token)
          (tokstruc-column-no token)
          msg)
  (uiop:quit 1))

(defun prt-ast (outf ast)
  ;;
  ;; For fun, let us do prt-ast *non*-recursively, with a stack and a
  ;; loop.
  ;;
  (let ((stack `(,ast)))
    (loop while stack
          do (let ((x (car stack)))
               (setf stack (cdr stack))
               (cond ((not x) (format outf ";~%"))
                     ((or (string= (car x) "Identifier")
                          (string= (car x) "Integer")
                          (string= (car x) "String"))
                      (format outf "~A ~A~%" (car x) (cadr x)))
                     (t (format outf "~A~%" (car x))
                        (setf stack (cons (caddr x) stack))
                        (setf stack (cons (cadr x) stack))))))))

(defun accept (gettok tok)
  (if (eq (tokstruc-tok (curr gettok)) tok)
      (nxt gettok)
      nil))

(defun expect (gettok msg tok)
  (let ((curr-tok (tokstruc-tok (curr gettok))))
    (if (eq curr-tok tok)
        (nxt gettok)
        (err (curr gettok)
             (join msg ": Expecting '"
                   (tok-text tok) "', found '"
                   (tok-text curr-tok) "'")))))

(defun parse (gettok)
  (defun paren-expr (gettok)
    (expect gettok "paren_expr" 'TOK-LEFTPAREN)
    (let ((x (expr gettok 0)))
      (expect gettok "paren_expr" 'TOK-RIGHTPAREN)
      x))

  (defun expr (gettok p)
    (let* ((tok (curr gettok))
           (x (case (tokstruc-tok tok)
                (TOK-LEFTPAREN (paren-expr gettok))
                (TOK-SUBTRACT
                 (nxt gettok)
                 (let ((y (expr gettok (precedence 'TOK-NEGATE))))
                   `("Negate" ,y ())))
                (TOK-ADD
                 (nxt gettok)
                 (expr gettok (precedence 'TOK-NEGATE)))
                (TOK-NOT
                 (nxt gettok)
                 (let ((y (expr gettok (precedence 'TOK-NOT))))
                   `("Not" ,y ())))
                (TOK-IDENTIFIER
                 (let ((y `("Identifier" ,(tokstruc-tokval tok))))
                   (nxt gettok)
                   y))
                (TOK-INTEGER
                 (let ((y `("Integer" ,(tokstruc-tokval tok))))
                   (nxt gettok)
                   y))
                (otherwise
                 (err tok (join "Expecting a primary, found: "
                                (tok-text (tokstruc-tok tok))))))))
      ;;
      ;; Precedence climbing for binary operators.
      ;;
      (loop for tok = (curr gettok)
            for toktok = (tokstruc-tok tok)
            while (and (binary-p toktok) (<= p (precedence toktok)))
            do (progn (nxt gettok)
                      (let ((q (if (right-associative-p toktok)
                                   (precedence toktok)
                                   (1+ (precedence toktok)))))
                        (setf x `(,(operator toktok) ,x
                                  ,(expr gettok q))))))
      x))

  (defun stmt (gettok)
    (cond ((accept gettok 'TOK-IF)
           (let* ((e (paren-expr gettok))
                  (s (stmt gettok))
                  (x (if (accept gettok 'TOK-ELSE)
                         `("If" ,s ,(stmt gettok))
                         `("If" ,s ()))))
             `("If" ,e ,x)))

          ((accept gettok 'TOK-PUTC)
           (let ((x `("Prtc" ,(paren-expr gettok) ())))
             (expect gettok "Putc" 'TOK-SEMICOLON)
             x))

          ((accept gettok 'TOK-PRINT)
           (expect gettok "Print" 'TOK-LEFTPAREN)
           (let ((x '()))
             (loop for tok = (curr gettok)
                   for toktok = (tokstruc-tok tok)
                   for e = (if (eq toktok 'TOK-STRING)
                               (let* ((tokval (tokstruc-tokval tok))
                                      (leaf `("String" ,tokval))
                                      (e `("Prts" ,leaf ())))
                                 (nxt gettok)
                                 e)
                               `("Prti" ,(expr gettok 0) ()))
                   do (setf x `("Sequence" ,x ,e))
                   while (accept gettok 'TOK-COMMA))
             (expect gettok "Print" 'TOK-RIGHTPAREN)
             (expect gettok "Print" 'TOK-SEMICOLON)
             x))

          ((eq (tokstruc-tok (curr gettok)) 'TOK-SEMICOLON)
           (nxt gettok))

          ((eq (tokstruc-tok (curr gettok)) 'TOK-IDENTIFIER)
           (let ((v `("Identifier" ,(tokstruc-tokval (curr gettok)))))
             (nxt gettok)
             (expect gettok "assign" 'TOK-ASSIGN)
             (let ((x `("Assign" ,v ,(expr gettok 0))))
               (expect gettok "assign" 'TOK-SEMICOLON)
               x)))

          ((accept gettok 'TOK-WHILE)
           (let ((e (paren-expr gettok)))
             `("While" ,e ,(stmt gettok))))

          ((accept gettok 'TOK-LEFTBRACE)
           (let ((x '()))
             (loop for tok = (curr gettok)
                   for toktok = (tokstruc-tok tok)
                   until (or (eq toktok 'TOK-RIGHTBRACE)
                             (eq toktok 'TOK-END-OF-INPUT))
                   do (setf x `("Sequence" ,x ,(stmt gettok))))
             (expect gettok "Lbrace" 'TOK-RIGHTBRACE)
             x))

          ((eq (tokstruc-tok (curr gettok)) 'TOK-END-OF-INPUT)
           '())

          (t (let* ((tok (curr gettok))
                    (toktok (tokstruc-tok tok)))
               (err tok (join "expecting start of statement, found '"
                              (tok-text toktok) "'"))))))

  ;;
  ;; Parsing of the top-level statement sequence.
  ;;
  (let ((x '()))
    (nxt gettok)
    (loop do (setf x `("Sequence" ,x ,(stmt gettok)))
          until (eq (tokstruc-tok (curr gettok)) 'TOK-END-OF-INPUT))
    x))

(defun string-to-tokstruc (s)
  (let ((strings
          (nth-value 1 (ppcre:scan-to-strings re-token-1 s))))
    (if strings
        (make-tokstruc :line-no (elt strings 0)
                       :column-no (elt strings 1)
                       :tok (string-to-tok (elt strings 2))
                       :tokval nil)
        (let ((strings
                (nth-value 1 (ppcre:scan-to-strings re-token-2 s))))
          (if strings
              (make-tokstruc :line-no (elt strings 0)
                             :column-no (elt strings 1)
                             :tok (string-to-tok (elt strings 2))
                             :tokval (elt strings 3))
              (progn
                (warn "unparseable token line")
                (uiop:quit 1)))))))

(defun read-token-line (inpf)
  (loop for line = (read-line inpf nil "End_of_input")
        while (ppcre:scan re-blank-line line)
        finally (return line)))

(defun open-inpf (inpf-filename)
  (if (string= inpf-filename "-")
      *standard-input*
      (open inpf-filename :direction :input)))

(defun open-outf (outf-filename)
  (if (string= outf-filename "-")
      *standard-output*
      (open outf-filename :direction :output
                          :if-exists :overwrite
                          :if-does-not-exist :create)))

(defun usage-error ()
  (princ "Usage: parse [INPUTFILE [OUTPUTFILE]]" *standard-output*)
  (terpri *standard-output*)
  (princ "If either INPUTFILE or OUTPUTFILE is \"-\", the respective"
         *standard-output*)
  (princ " standard I/O is used." *standard-output*)
  (terpri *standard-output*)
  (uiop:quit 1))

(defun get-filenames (argv)
  (trivia:match argv
    ((list) '("-" "-"))
    ((list inpf-filename) `(,inpf-filename "-"))
    ((list inpf-filename outf-filename) `(,inpf-filename
                                          ,outf-filename))
    (_ (usage-error))))

(defun main (&rest argv)
  (let* ((filenames (get-filenames argv))
         (inpf-filename (car filenames))
         (inpf (open-inpf inpf-filename))
         (outf-filename (cadr filenames))
         (outf (open-outf outf-filename)))

    (let* ((current-token (list nil))
           (gettok-curr (lambda () (elt current-token 0)))
           (gettok-nxt (lambda ()
                         (let* ((s (read-token-line inpf))
                                (tok (string-to-tokstruc s)))
                           (setf (elt current-token 0) tok)
                           tok)))
           (gettok (lambda (instruction)
                     (trivia:match instruction
                       (:curr (funcall gettok-curr))
                       (:nxt (funcall gettok-nxt)))))
           (ast (parse gettok)))
      (prt-ast outf ast))

    (unless (string= inpf-filename "-")
      (close inpf))
    (unless (string= outf-filename "-")
      (close outf))

    (uiop:quit 0)))

;;; vim: set ft=lisp lisp:
