(defun tokenize-stream (stream)
  (labels ((whitespace-p (char)
             (find char #(#\space #\newline #\return #\tab)))
           (consume-whitespace ()
             (loop while (whitespace-p (peek-char nil stream nil #\a))
                   do (read-char stream)))
           (read-integer ()
             (loop while (digit-char-p (peek-char nil stream nil #\space))
                   collect (read-char stream) into digits
                   finally (return (parse-integer (coerce digits 'string))))))
    (consume-whitespace)
    (let* ((c (peek-char nil stream nil nil)))
           (token (case c
                     (nil nil)
                     (#\( :lparen)
                     (#\) :rparen)
                     (#\* '*)
                     (#\/ '/)
                     (#\+ '+)
                     (#\- '-)
                     (otherwise
                       (unless (digit-char-p c)
                         (cerror "Skip it." "Unexpected character ~w." c)
                         (read-char stream)
                         (return-from tokenize-stream
                                      (tokenize-stream stream)))
                       (read-integer)))))
        (unless (or (null token) (integerp token))
          (read-char stream))
        token)))

(defun group-parentheses (tokens &optional (delimited nil))
  (do ((new-tokens '()))
      ((endp tokens)
       (when delimited
         (cerror "Insert it."  "Expected right parenthesis."))
       (values (nreverse new-tokens) '()))
    (let ((token (pop tokens)))
      (case token
        (:lparen
         (multiple-value-bind (group remaining-tokens)
             (group-parentheses tokens t)
           (setf new-tokens (cons group new-tokens)
                 tokens remaining-tokens)))
        (:rparen
         (if (not delimited)
           (cerror "Ignore it." "Unexpected right parenthesis.")
           (return (values (nreverse new-tokens) tokens))))
        (otherwise
         (push token new-tokens))))))

(defun group-operations (expression)
  (flet ((gop (exp) (group-operations exp)))
    (if (integerp expression)
      expression
      (destructuring-bind (a &optional op1 b op2 c &rest others)
                          expression
        (unless (member op1 '(+ - * / nil))
          (error "syntax error: in expr ~a expecting operator, not ~a"
                 expression op1))
        (unless (member op2 '(+ - * / nil))
          (error "syntax error: in expr ~a expecting operator, not ~a"
                 expression op2))
        (cond
         ((not op1) (gop a))
         ((not op2) `(,(gop a) ,op1 ,(gop b)))
         (t (let ((a (gop a)) (b (gop b)) (c (gop c)))
              (if (and (member op1 '(+ -)) (member op2 '(* /)))
                (gop `(,a ,op1 (,b ,op2 ,c) ,@others))
                (gop `((,a ,op1 ,b) ,op2 ,c ,@others))))))))))

(defun infix-to-prefix (expression)
  (if (integerp expression)
    expression
    (destructuring-bind (a op b) expression
      `(,op ,(infix-to-prefix a) ,(infix-to-prefix b)))))

(defun evaluate (string)
  (with-input-from-string (in string)
    (eval
      (infix-to-prefix
        (group-operations
          (group-parentheses
            (loop for token = (tokenize-stream in)
                  until (null token)
                  collect token)))))))
