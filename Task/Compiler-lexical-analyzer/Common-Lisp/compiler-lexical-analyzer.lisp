(defpackage #:lexical-analyzer
  (:use #:cl #:sb-gray)
  (:export #:main))

(in-package #:lexical-analyzer)

(defconstant +lex-symbols-package+ (or (find-package :lex-symbols)
                                       (make-package :lex-symbols)))

(defclass counting-character-input-stream (fundamental-character-input-stream)
  ((stream :type stream :initarg :stream :reader stream-of)
   (line :type fixnum :initform 1 :accessor line-of)
   (column :type fixnum :initform 0 :accessor column-of)
   (prev-column :type (or null fixnum) :initform nil :accessor prev-column-of))
  (:documentation "Character input stream that counts lines and columns."))

(defmethod stream-read-char ((stream counting-character-input-stream))
  (let ((ch (read-char (stream-of stream) nil :eof)))
    (case ch
      (#\Newline
       (incf (line-of stream))
       (setf (prev-column-of stream) (column-of stream)
             (column-of stream) 0))
      (t
       (incf (column-of stream))))
    ch))

(defmethod stream-unread-char ((stream counting-character-input-stream) char)
  (unread-char char (stream-of stream))
  (case char
      (#\Newline
       (decf (line-of stream))
       (setf (column-of stream) (prev-column-of stream)))
      (t
       (decf (column-of stream)))))

(defstruct token
  (name nil :type symbol)
  (value nil :type t)
  (line nil :type fixnum)
  (column nil :type fixnum))

(defun lexer-error (format-control &rest args)
  (apply #'error format-control args))

(defun handle-divide-or-comment (stream char)
  (declare (ignore char))
  (case (peek-char nil stream t nil t)
    (#\* (loop with may-end = nil
                 initially (read-char stream t nil t)
               for ch = (read-char stream t nil t)
               until (and may-end (char= ch #\/))
               do (setf may-end (char= ch #\*))
               finally (return (read stream t nil t))))
    (t (make-token :name :op-divide :line (line-of stream) :column (column-of stream)))))

(defun make-constant-handler (token-name)
  (lambda (stream char)
    (declare (ignore char))
    (make-token :name token-name :line (line-of stream) :column (column-of stream))))

(defun make-this-or-that-handler (expect then &optional else)
  (lambda (stream char)
    (declare (ignore char))
    (let ((line (line-of stream))
          (column (column-of stream))
          (next (peek-char nil stream nil nil t)))
      (cond ((and expect (char= next expect))
             (read-char stream nil nil t)
             (make-token :name then :line line :column column))
            (else
             (make-token :name else :line line :column column))
            (t
             (lexer-error "Unrecognized character '~A'" next))))))

(defun identifier? (symbol)
  (and (symbolp symbol)
       (not (keywordp symbol))
       (let ((name (symbol-name symbol)))
         (and (find (char name 0) "_abcdefghijklmnopqrstuvwxyz" :test #'char-equal)
              (or (< (length name) 2)
                  (not (find-if-not (lambda (ch)
                                      (find ch "_abcdefghijklmnopqrstuvwxyz0123456789"
                                            :test #'char-equal))
                                    name :start 1)))))))

(defun id->keyword (id line column)
  (case id
    (lex-symbols::|if|    (make-token :name :keyword-if :line line :column column))
    (lex-symbols::|else|  (make-token :name :keyword-else :line line :column column))
    (lex-symbols::|while| (make-token :name :keyword-while :line line :column column))
    (lex-symbols::|print| (make-token :name :keyword-print :line line :column column))
    (lex-symbols::|putc|  (make-token :name :keyword-putc :line line :column column))
    (t nil)))

(defun handle-identifier (stream char)
  (let ((*readtable* (copy-readtable)))
    (set-syntax-from-char char #\z)
    (let ((line (line-of stream))
          (column (column-of stream)))
      (unread-char char stream)
      (let ((obj (read stream t nil t)))
        (if (identifier? obj)
            (or (id->keyword obj line column)
                (make-token :name :identifier :value obj :line line :column column))
            (lexer-error "Invalid identifier name: ~A" obj))))))

(defun handle-integer (stream char)
  (let ((*readtable* (copy-readtable)))
    (set-syntax-from-char char #\z)
    (let ((line (line-of stream))
          (column (column-of stream)))
      (unread-char char stream)
      (let ((obj (read stream t nil t)))
        (if (integerp obj)
            (make-token :name :integer :value obj :line line :column column)
            (lexer-error "Invalid integer: ~A" obj))))))

(defun handle-char-literal (stream char)
  (declare (ignore char))
  (let* ((line (line-of stream))
         (column (column-of stream))
         (ch (read-char stream t nil t))
         (parsed (case ch
                   (#\' (lexer-error "Empty character constant"))
                   (#\Newline (lexer-error "New line in character literal"))
                   (#\\ (let ((next-ch (read-char stream t nil t)))
                          (case next-ch
                            (#\n #\Newline)
                            (#\\ #\\)
                            (t (lexer-error "Unknown escape sequence: \\~A" next-ch)))))
                   (t ch))))
    (if (char= #\' (read-char stream t nil t))
        (make-token :name :integer :value (char-code parsed) :line line :column column)
        (lexer-error "Only one character is allowed in character literal"))))

(defun handle-string (stream char)
  (declare (ignore char))
  (loop with result = (make-array 0 :element-type 'character :adjustable t :fill-pointer t)
        with line = (line-of stream)
        with column = (column-of stream)
        for ch = (read-char stream t nil t)
        until (char= ch #\")
        do (setf ch (case ch
                      (#\Newline (lexer-error "New line in string"))
                      (#\\ (let ((next-ch (read-char stream t nil t)))
                             (case next-ch
                               (#\n #\Newline)
                               (#\\ #\\)
                               (t (lexer-error "Unknown escape sequence: \\~A" next-ch)))))
                      (t ch)))
           (vector-push-extend ch result)
        finally (return (make-token :name :string :value result :line line :column column))))

(defun make-lexer-readtable ()
  (let ((*readtable* (copy-readtable nil)))
    (setf (readtable-case *readtable*) :preserve)
    (set-syntax-from-char #\\ #\z)
    (set-syntax-from-char #\# #\z)
    (set-syntax-from-char #\` #\z)

    ;; operators
    (set-macro-character #\* (make-constant-handler :op-multiply))
    (set-macro-character #\/ #'handle-divide-or-comment)
    (set-macro-character #\% (make-constant-handler :op-mod))
    (set-macro-character #\+ (make-constant-handler :op-add))
    (set-macro-character #\- (make-constant-handler :op-subtract))
    (set-macro-character #\< (make-this-or-that-handler #\= :op-lessequal :op-less))
    (set-macro-character #\> (make-this-or-that-handler #\= :op-greaterequal :op-greater))
    (set-macro-character #\= (make-this-or-that-handler #\= :op-equal :op-assign))
    (set-macro-character #\! (make-this-or-that-handler #\= :op-notequal :op-not))
    (set-macro-character #\& (make-this-or-that-handler #\& :op-and))
    (set-macro-character #\| (make-this-or-that-handler #\| :op-or))

    ;; symbols
    (set-macro-character #\( (make-constant-handler :leftparen))
    (set-macro-character #\) (make-constant-handler :rightparen))
    (set-macro-character #\{ (make-constant-handler :leftbrace))
    (set-macro-character #\} (make-constant-handler :rightbrace))
    (set-macro-character #\; (make-constant-handler :semicolon))
    (set-macro-character #\, (make-constant-handler :comma))

    ;; identifiers & keywords
    (set-macro-character #\_ #'handle-identifier t)
    (loop for ch across "abcdefghijklmnopqrstuvwxyz"
          do (set-macro-character ch #'handle-identifier t))
    (loop for ch across "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
          do (set-macro-character ch #'handle-identifier t))

    ;; integers
    (loop for ch across "0123456789"
          do (set-macro-character ch #'handle-integer t))
    (set-macro-character #\' #'handle-char-literal)

    ;; strings
    (set-macro-character #\" #'handle-string)

    *readtable*))

(defun lex (stream)
  (loop with *readtable* = (make-lexer-readtable)
        with *package* = +lex-symbols-package+
        with eof = (gensym)
        with counting-stream = (make-instance 'counting-character-input-stream :stream stream)
        for token = (read counting-stream nil eof)
        until (eq token eof)
        do (format t "~5D ~5D ~15A~@[ ~S~]~%"
                   (token-line token) (token-column token) (token-name token) (token-value token))
        finally (format t "~5D ~5D ~15A~%"
                        (line-of counting-stream) (column-of counting-stream) :end-of-input)
                (close counting-stream)))

(defun main ()
  (lex *standard-input*))
