;;;; Parsing/infix to RPN conversion
(defconstant operators "^*/+-")
(defconstant precedence '(-4 3 3 2 2))

(defun operator-p (op)
  "string->integer|nil: Returns operator precedence index or nil if not operator."
  (and (= (length op) 1) (position (char op 0) operators)))

(defun has-priority (op2 op1)
  "(string,string)->boolean: True if op2 has output priority over op1."
  (defun prec (op) (nth (operator-p op) precedence))
  (or (and (plusp (prec op1))  (<= (prec op1) (abs (prec op2))))
      (and (minusp (prec op1)) (< (- (prec op1)) (abs (prec op2))))))

(defun string-split (expr)
  "string->list: Tokenize a space separated string."
  (let* ((p (position #\Space expr))
         (tok (if p (subseq expr 0 p) expr)))
    (if p (append (list tok) (string-split (subseq expr (1+ p)))) (list tok))))

(defun classify (tok)
  "nil|string->symbol: Classify a token."
  (cond
   ((null tok) 'NOL)
   ((operator-p tok) 'OPR)
   ((string= tok "(") 'LPR)
   ((string= tok ")") 'RPR)
   (t 'LIT)))

;;; transitions when op2 is dont care
(defconstant trans1D '((LIT GO) (LPR ENTER)))
;;; transitions when we check op2 also
(defconstant trans2D
  '((OPR ((NOL ENTER)
          (LPR ENTER)
          (OPR (lambda (op1 op2) (if (has-priority op2 op1) 'LEAVE 'ENTER)))))
    (RPR ((NOL "mismatched parentheses")
          (LPR CLEAR)
          (OPR LEAVE)))
    (NOL ((NOL nil)
          (LPR "mismatched parentheses")
          (OPR LEAVE)))))

(defun do-signal (op1 op2)
  "(nil|string,nil|string)->symbol|string|nil: Emit a signal based on state of inputq and opstack.
   A nil return is a successful lookup (on nil,nil) because all input combinations are specified."
  (let ((sig (or (cadr (assoc (classify op1) trans1D))
                 (cadr (assoc (classify op2) (cadr (assoc (classify op1) trans2D)))))))
    (if (or (null sig) (symbolp sig) (stringp sig)) sig
        (funcall (coerce sig 'function) op1 op2))))

(defun rpn (expr)
  "string->string: Parse infix expression into rpn."
  (format t "TOKEN  TOS    SIGNAL     OPSTACK       OUTPUTQ~%")

  ;; iterate until both stacks empty
  (do* ((input (string-split expr)) (opstack nil) (outputq "")
        (sig (do-signal (first input) (first opstack)) (do-signal (first input) (first opstack))))
       ((null sig) ; until
        ;; print last closing frame
        (format t "~A~7,T~A~14,T~A~25,T~A~38,T~A~%" nil nil nil opstack outputq)
        (subseq outputq 1)) ; return final infix expression

    ;; print opening frame
    (format t "~A~7,T~A~14,T" (first input) (first opstack))
    (format t (if (stringp sig) "\"~A\"" "~A") sig)

    ;; switch state
    (let ((output (case sig
                    (GO     (pop input))
                    (ENTER  (push (pop input) opstack) nil)
                    (LEAVE  (pop opstack))
                    (CLEAR  (pop input) (pop opstack) nil)
                    (otherwise (pop input) (pop opstack)
                               (if (stringp sig) sig "unknown signal")))))
      (when output (setf outputq (concatenate 'string outputq " " output))))

    ;; print closing frame
    (format t "~25,T~A~38,T~A~%" opstack outputq))) ; end-do

(defun main (&optional (xtra nil))
  "nil->[printed rpn expressions]: Main function."
  (let ((expressions '("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
                       "( ( 1 + 2 ) ^ ( 3 + 4 ) ) ^ ( 5 + 6 )"
                       "( ( 3 ^ 4 ) ^ 2 ^ 9 ) ^ 2 ^ 5"
                       "3 + 4 * ( 5 - 6 ) ) 4 * 9")))
    (dolist (expr (if xtra expressions (list (car expressions))))
      (format t "~%INFIX:\"~A\"~%" expr)
      (format t "RPN:\"~A\"~%" (rpn expr)))))
