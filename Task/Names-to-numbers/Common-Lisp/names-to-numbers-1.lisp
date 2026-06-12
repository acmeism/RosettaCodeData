(defpackage number-names
  (:use cl))

(in-package number-names)

(defparameter *ones*
  '((one   . 1)
    (two   . 2)
    (three . 3)
    (four  . 4)
    (five  . 5)
    (six   . 6)
    (seven . 7)
    (eight . 8)
    (nine  . 9)))

(defparameter *teens*
  '((ten       . 10)
    (eleven    . 11)
    (twelve    . 12)
    (thirteen  . 13)
    (fourteen  . 14)
    (fifteen   . 15)
    (sixteen   . 16)
    (seventeen . 17)
    (eighteen  . 18)
    (nineteen  . 19)))

(defparameter *tens*
  '((twenty  . 20)
    (thirty  . 30)
    (forty   . 40)
    (fifty   . 50)
    (sixty   . 60)
    (seventy . 70)
    (eighty  . 80)
    (ninety  . 90)))

(defparameter *hundred*
  '((hundred . 100)))

(defparameter *illions*
  '((quintillion . 1000000000000000000)
    (quadrillion . 1000000000000000)
    (trillion    . 1000000000000)
    (billion     . 1000000000)
    (million     . 1000000)
    (thousand    . 1000)))

(defparameter *delims* '(#\Space #\Tab #\Newline #\-))

;; Turn a single delimited word into an atom.
(defun tokenize-word (word)
  (let ((stream (make-string-output-stream)))
    (loop do
         (let ((char (pop word)))
           (cond ((null char) (return))
                 ((member char *delims*) (return))
                 (t (write-char char stream)))))
    (let ((out (get-output-stream-string stream)))
      (values (intern (string-upcase out) 'number-names)
              word))))

;; Tokenize the input string.
(defun tokenize (word)
  (let ((word (coerce word 'list))
        (tokens (list)))
    (loop do
         (let ((char (pop word)))
           (cond ((null char) (return))
                 ((member char *delims*) nil)
                 (t (multiple-value-bind (token rest-word)
                        (tokenize-word (push char word))
                      (setf word rest-word)
                      (push token tokens))))))
    (reverse tokens)))

;; Define a state machine to parse a subsection of a number
;; that precedes an -illion.
(defmacro defstate (name end-transitions-p &rest transitions)
  (let ((token (gensym "TOKEN"))
        (number (gensym "NUMBER"))
        (illions (gensym "ILLIONS"))
        (illion (gensym "ILLION")))
  `(defun ,name (,token ,number ,illions)
     ,(append '(cond)
              (loop for trans in transitions collect
                   (destructuring-bind (place to-state op) trans
                     `((assoc ,token ,place)
                       (values ',to-state
                               (,op ,number (cdr (assoc ,token ,place)))))))
              (when end-transitions-p
                `(((assoc ,token ,illions)
                   (throw 'done
                     (let ((,illion (assoc ,token ,illions)))
                       (values (* ,number (cdr ,illion)) (car ,illion)))))
                  ((null ,token) (throw 'done (values ,number nil)))))
              `((t (error "Unexpected token ~a" ,token)))))))

(defstate state-a nil
  (*ones* state-b +)
  (*tens* state-d +)
  (*teens* state-e +))

(defstate state-b t
  (*hundred* state-c *))

(defstate state-c t
  (*ones* state-e +)
  (*tens* state-d +)
  (*teens* state-e +))

(defstate state-d t
  (*ones* state-e +))

(defstate state-e t)

(defun consume-illions (illion illions)
  (cond ((null illions) nil)
        ((eq illion (caar illions)) (cdr illions))
        (t (consume-illions illion (cdr illions)))))

;; Parse a number up to the next -illion.
;; Errors on numbers that (format t "~R" ..)
;; would not generate, like "one thousand one million".
(defun parse-sub-number (tokens illions)
  (let ((number 0)
        (state 'state-a))
    (multiple-value-bind (number illion)
        (catch 'done
          (loop do
               (let ((token (pop tokens)))
                 (multiple-value-bind (next-state next-number)
                     (funcall state token number illions)
                   (setf state next-state)
                   (setf number next-number)))))
      (values number
              (if illion
                  (consume-illions illion illions)
                  illions)
              tokens))))

;; Parse the list of tokenized number parts.
(defun parse-number (tokens)
  (let ((illions *illions*)
        (total 0)
        (negative-p (eq (car tokens) 'negative)))
    (when negative-p (pop tokens))
    (if (eq (car tokens) 'zero)
        (if (null (cdr tokens))
            0
            (error "Unexpected token ~a" (cadr tokens)))
        (loop do
             (multiple-value-bind (number new-illions rest-tokens)
                 (parse-sub-number tokens illions)
               (setf illions new-illions)
               (incf total number)
               (setf tokens rest-tokens)
               (unless tokens (return (* (if negative-p -1 1) total))))))))

(defun parse (word)
  (parse-number (tokenize word)))

(defun test ()
  (let ((test-numbers
         '(+0
           -3
           +5
           -7
           +11
           -13
           +17
           -19
           +23
           -29
           201021002001
           -20102100201
           2010210020
           -201021002
           20102100
           -2010210
           201021
           -20103
           2010
           -201
           20
           -2
           0)))
    (princ "number => (format t \"~R\" number) => (parse (format t \"~R\" number))")
    (terpri)
    (mapc (lambda (number)
            (let ((word (format nil "~R" number)))
              (format t "~a => ~a => ~a~%" number word (parse word))))
          test-numbers))
  (values))
