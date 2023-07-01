;;;; Parsing/RPN to infix conversion
(defstruct (node (:print-function print-node)) opr infix)
(defun print-node (node stream depth)
  (format stream "opr:=~A infix:=\"~A\"" (node-opr node) (node-infix node)))

(defconstant OPERATORS '((#\^ . 4) (#\* . 3) (#\/ . 3) (#\+ . 2) (#\- . 2)))

;;; (char,char[,boolean])->boolean
(defun higher-p (opp opc &optional (left-node-p nil))
  (or (> (cdr (assoc opp OPERATORS)) (cdr (assoc opc OPERATORS)))
      (and left-node-p (char= opp #\^) (char= opc #\^))))

;;; string->list
(defun string-split (expr)
  (let ((p (position #\Space expr)))
    (if (null p) (list expr)
        (append (list (subseq expr 0 p))
                (string-split (subseq expr (1+ p)))))))

;;; string->string
(defun parse (expr)
  (let ((stack '()))
    (format t "TOKEN   STACK~%")
    (dolist (tok (string-split expr))
      (if (assoc (char tok 0) OPERATORS) ; operator?
          (push (make-node :opr (char tok 0) :infix (infix (char tok 0) (pop stack) (pop stack))) stack)
          (push tok stack))

      ;; print stack at each token
      (format t "~3,A" tok)
      (dotimes (i (length stack)) (format t "~8,T[~D] ~A~%" i (nth i stack))))

    ;; print final infix expression
    (if (= (length stack) 1)
        (format nil "~A" (node-infix (first stack)))
        (format nil "syntax error in ~A" expr))))

;;; (char,node,node)->string
(defun infix (operator rightn leftn)

  ;; (char,node[,boolean]->string
  (defun string-node (operator anode &optional (left-node-p nil))
    (if (stringp anode) anode
        (if (higher-p operator (node-opr anode) left-node-p)
            (format nil "( ~A )" (node-infix anode)) (node-infix anode))))

  (concatenate 'string
               (string-node operator leftn t)
               (format nil " ~A " operator)
               (string-node operator rightn)))

;;; nil->[printed infix expressions]
(defun main ()
  (let ((expressions '("3 4 2 * 1 5 - 2 3 ^ ^ / +"
                       "1 2 + 3 4 + ^ 5 6 + ^"
                       "3 4 ^ 2 9 ^ ^ 2 5 ^ ^")))
    (dolist (expr expressions)
      (format t "~%Parsing:\"~A\"~%" expr)
      (format t "RPN:\"~A\" INFIX:\"~A\"~%" expr (parse expr)))))
