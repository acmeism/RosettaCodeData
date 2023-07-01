#!/usr/bin/emacs --script
;;
;; The Rosetta Code lexical analyzer in GNU Emacs Lisp.
;;
;; Migrated from the ATS. However, Emacs Lisp is not friendly to the
;; functional style of the ATS implementation; therefore the
;; differences are vast.
;;
;; (A Scheme migration could easily, on the other hand, have been
;; almost exact. It is interesting to contrast Lisp dialects and see
;; how huge the differences are.)
;;
;; The script currently takes input only from standard input and
;; writes the token stream only to standard output.
;;

(require 'cl-lib)

;;; The type of a character, consisting of its code point and where it
;;; occurred in the text.
(cl-defstruct (ch_t (:constructor make-ch (ichar line-no column-no)))
  ichar line-no column-no)

(defun ch-ichar (ch)
  (ch_t-ichar ch))

(defun ch-line-no (ch)
  (ch_t-line-no ch))

(defun ch-column-no (ch)
  (ch_t-column-no ch))

;;; The type of an "inputter", consisting of an open file for the
;;; text, a pushback buffer (which is an indefinitely deep stack of
;;; ch_t), an input buffer for the current line, and a position in the
;;; text.
(cl-defstruct inp_t file pushback line line-no column-no)

(defun make-inp (file)
  "Initialize a new inp_t."
  (make-inp_t :file file
              :pushback '()
              :line ""
              :line-no 0
              :column-no 0))

(defvar inp (make-inp t)
  "A global inp_t.")

(defun get-ch ()
  "Get a ch_t, either from the pushback buffer or from the input."
  (pcase (inp_t-pushback inp)
    (`(,ch . ,tail)
     ;; Emacs Lisp has only single value return, so the results come
     ;; back as a list rather than multiple values.
     (setq inp (make-inp_t :file (inp_t-file inp)
                           :pushback tail
                           :line (inp_t-line inp)
                           :line-no (inp_t-line-no inp)
                           :column-no (inp_t-column-no inp)))
     ch)
    ('()
     (let ((line (inp_t-line inp))
           (line-no (inp_t-line-no inp))
           (column-no (inp_t-column-no inp)))
       (when (string= line "")
         ;; Refill the buffer.
         (let ((text
                (condition-case nil (read-string "")
                  nil (error 'eoi))))
           (if (eq text 'eoi)
               (setq line 'eoi)
             (setq line (format "%s%c" text ?\n)))
           (setq line-no (1+ line-no))
           (setq column-no 1)))
       (if (eq line 'eoi)
           (progn
             (setq inp (make-inp_t :file (inp_t-file inp)
                                   :pushback (inp_t-pushback inp)
                                   :line line
                                   :line-no line-no
                                   :column-no column-no))
             (make-ch 'eoi line-no column-no))
         (let ((c (elt line 0))
               (line (substring line 1)))
           (setq inp (make-inp_t :file (inp_t-file inp)
                                 :pushback (inp_t-pushback inp)
                                 :line line
                                 :line-no line-no
                                 :column-no (1+ column-no)))
           (make-ch c line-no column-no)))))))

(defun get-new-line (file)
  ;; Currently "file" is ignored and the input must be from stdin.
  (read-from-minibuffer "" :default 'eoi))

(defun push-back (ch)
  "Push back a ch_t."
  (setq inp (make-inp_t :file (inp_t-file inp)
                        :pushback (cons ch (inp_t-pushback inp))
                        :line (inp_t-line inp)
                        :line-no (inp_t-line-no inp)
                        :column-no (inp_t-column-no inp))))

(defun get-position ()
  "Return the line-no and column-no of the next ch_t to be
returned by get-ch, assuming there are no more pushbacks
beforehand."
  (let* ((ch (get-ch))
         (line-no (ch-line-no ch))
         (column-no (ch-column-no ch)))
    (push-back ch)
    (list line-no column-no)))

(defun scan-text (outf)
  "The main loop."
  (cl-loop for toktup = (get-next-token)
           do (print-token outf toktup)
           until (string= (elt toktup 0) "End_of_input")))

(defun print-token (outf toktup)
  "Print a token, along with its position and possibly an
argument."
  ;; Currently outf is ignored, and the output goes to stdout.
  (pcase toktup
    (`(,tok ,arg ,line-no ,column-no)
     (princ (format "%5d %5d  %s" line-no column-no tok))
     (pcase tok
       ("Identifier" (princ (format "     %s\n" arg)))
       ("Integer" (princ (format "        %s\n" arg)))
       ("String" (princ (format "         %s\n" arg)))
       (_ (princ "\n"))))))

(defun get-next-token ()
   "The token dispatcher. Returns the next token, as a list along
with its argument and text position."
   (skip-spaces-and-comments)
   (let* ((ch (get-ch))
          (ln (ch-line-no ch))
          (cn (ch-column-no ch)))
     (pcase (ch-ichar ch)
       ('eoi (list "End_of_input" "" ln cn))
       (?, (list "Comma" "," ln cn))
       (?\N{SEMICOLON} (list "Semicolon" ";" ln cn))
       (?\N{LEFT PARENTHESIS} (list "LeftParen" "(" ln cn))
       (?\N{RIGHT PARENTHESIS} (list "RightParen" ")" ln cn))
       (?{ (list "LeftBrace" "{" ln cn))
       (?} (list "RightBrace" "}" ln cn))
       (?* (list "Op_multiply" "*" ln cn))
       (?/ (list "Op_divide" "/" ln cn))
       (?% (list "Op_mod" "%" ln cn))
       (?+ (list "Op_add" "+" ln cn))
       (?- (list "Op_subtract" "-" ln cn))
       (?< (let ((ch1 (get-ch)))
             (pcase (ch-ichar ch1)
               (?= (list "Op_lessequal" "<=" ln cn))
               (_ (push-back ch1)
                  (list "Op_less" "<" ln cn)))))
       (?> (let ((ch1 (get-ch)))
             (pcase (ch-ichar ch1)
               (?= (list "Op_greaterequal" ">=" ln cn))
               (_ (push-back ch1)
                  (list "Op_greater" ">" ln cn)))))
       (?= (let ((ch1 (get-ch)))
             (pcase (ch-ichar ch1)
               (?= (list "Op_equal" "==" ln cn))
               (_ (push-back ch1)
                  (list "Op_assign" "=" ln cn)))))
       (?! (let ((ch1 (get-ch)))
             (pcase (ch-ichar ch1)
               (?= (list "Op_notequal" "!=" ln cn))
               (_ (push-back ch1)
                  (list "Op_not" "!" ln cn)))))
       (?& (let ((ch1 (get-ch)))
             (pcase (ch-ichar ch1)
               (?& (list "Op_and" "&&" ln cn))
               (_ (unexpected-character ln cn (get-ichar ch))))))
       (?| (let ((ch1 (get-ch)))
             (pcase (ch-ichar ch1)
               (?| (list "Op_or" "||" ln cn))
               (_ (unexpected-character ln cn (get-ichar ch))))))
       (?\N{QUOTATION MARK} (push-back ch) (scan-string-literal))
       (?\N{APOSTROPHE} (push-back ch) (scan-character-literal))
       ((pred digitp) (push-back ch) (scan-integer-literal))
       ((pred identifier-start-p)
        (progn
          (push-back ch)
          (scan-identifier-or-reserved-word)))
       (c (unexpected-character ln cn c)))))

(defun skip-spaces-and-comments ()
  "Skip spaces and comments. A comment is treated as equivalent
to a run of spaces."
  (cl-loop for ch = (let ((ch1 (get-ch)))
                      (pcase (ch-ichar ch1)
                        (?/ (let* ((ch2 (get-ch))
                                   (line-no (ch-line-no ch1))
                                   (column-no (ch-column-no ch1))
                                   (position `(,line-no ,column-no)))
                              (pcase (ch-ichar ch2)
                                (?* (scan-comment position)
                                    (get-ch))
                                (_ (push-back ch2)
                                   ch1))))
                        (_ ch1)))
           while (spacep (ch-ichar ch))
           finally do (push-back ch)))

(defun scan-comment (position)
  (cl-loop for ch = (get-ch)
           for done = (comment-done-p ch position)
           until done))

(defun comment-done-p (ch position)
  (pcase (ch-ichar ch)
    ('eoi (apply 'unterminated-comment position))
    (?* (let ((ch1 (get-ch)))
          (pcase (ch-ichar ch1)
            ('eoi (apply 'unterminated-comment position))
            (?/ t)
            (_ nil))))
    (_ nil)))

(defun scan-integer-literal ()
  "Scan an integer literal, on the assumption that a digit has
been seen and pushed back."
  (let* ((position (get-position))
         (lst (scan-word))
         (s (list-to-string lst)))
    (if (all-digits-p lst)
        `("Integer" ,s . ,position)
      (apply 'illegal-integer-literal `(,@position , s)))))

(defun scan-identifier-or-reserved-word ()
   "Scan an identifier or reserved word, on the assumption that a
legal first character (for an identifier) has been seen and
pushed back."
   (let* ((position (get-position))
          (lst (scan-word))
          (s (list-to-string lst))
          (tok (pcase s
                 ("else" "Keyword_else")
                 ("if" "Keyword_if")
                 ("while" "Keyword_while")
                 ("print" "Keyword_print")
                 ("putc" "Keyword_putc")
                 (_ "Identifier"))))
     `(,tok ,s . ,position)))

(defun scan-word ()
  (cl-loop for ch = (get-ch)
           while (identifier-continuation-p (ch-ichar ch))
           collect (ch-ichar ch)
           finally do (push-back ch)))

(defun scan-string-literal ()
    "Scan a string literal, on the assumption that a double quote
has been seen and pushed back."
  (let* ((ch (get-ch))
         (_ (cl-assert (= (ch-ichar ch) ?\N{QUOTATION MARK})))
         (line-no (ch-line-no ch))
         (column-no (ch-column-no ch))
         (position `(,line-no ,column-no))
         (lst (scan-str-lit position))
         (lst `(?\N{QUOTATION MARK} ,@lst ?\N{QUOTATION MARK})))
    `("String" ,(list-to-string lst) . ,position)))

(defun scan-str-lit (position)
  (flatten
   (cl-loop for ch = (get-ch)
            until (= (ch-ichar ch) ?\N{QUOTATION MARK})
            collect (process-str-lit-character
                     (ch-ichar ch) position))))

(defun process-str-lit-character (c position)
  ;; NOTE: This script might insert a newline before any eoi, so that
  ;; "end-of-input-in-string-literal" never actually occurs. It is a
  ;; peculiarity of the script's input mechanism.
  (pcase c
    ('eoi (apply 'end-of-input-in-string-literal position))
    (?\n (apply 'end-of-line-in-string-literal position))
    (?\\ (let ((ch1 (get-ch)))
           (pcase (ch-ichar ch1)
             (?n '(?\\ ?n))
             (?\\ '(?\\ ?\\))
             (c (unsupported-escape (ch-line-no ch1)
                                    (ch-column-no ch1)
                                    c)))))
    (c c)))

(defun scan-character-literal ()
  "Scan a character literal, on the assumption that an ASCII
single quote (that is, a Unicode APOSTROPHE) has been seen and
pushed back."
  (let* ((toktup (scan-character-literal-without-checking-end))
         (line-no (elt toktup 2))
         (column-no (elt toktup 3))
         (position (list line-no column-no)))
    (check-char-lit-end position)
    toktup))

(defun check-char-lit-end (position)
  (let ((ch (get-ch)))
    (unless (and (integerp (ch-ichar ch))
                 (= (ch-ichar ch) ?\N{APOSTROPHE}))
      (push-back ch)
      (loop-to-char-lit-end position))))

(defun loop-to-char-lit-end (position)
  (cl-loop for ch = (get-ch)
           until (or (eq (ch-ichar ch) 'eoi)
                     (= (ch-ichar ch) ?\N{APOSTROPHE}))
           finally do (if (eq (ch-ichar ch) 'eoi)
                          (apply 'unterminated-character-literal
                                 position)
                        (apply 'multicharacter-literal position))))

(defun scan-character-literal-without-checking-end ()
  (let* ((ch (get-ch))
         (_ (cl-assert (= (ch-ichar ch) ?\N{APOSTROPHE})))
         (line-no (ch-line-no ch))
         (column-no (ch-column-no ch))
         (position (list line-no column-no))
         (ch1 (get-ch)))
    (pcase (ch-ichar ch1)
      ('eoi (apply 'unterminated-character-literal position))
      (?\\ (let ((ch2 (get-ch)))
             (pcase (ch-ichar ch2)
               ('eoi (apply 'unterminated-character-literal position))
               (?n `("Integer" ,(format "%d" ?\n) . ,position))
               (?\\ `("Integer" ,(format "%d" ?\\) . ,position))
               (c (unsupported-escape (ch-line-no ch1)
                                      (ch-column-no ch1)
                                      c)))))
      (c `("Integer" ,(format "%d" c) . ,position)))))

(defun spacep (c)
  (and (integerp c) (or (= c ?\N{SPACE})
                        (and (<= 9 c) (<= c 13)))))

(defun digitp (c)
  (and (integerp c) (<= ?0 c) (<= c ?9)))

(defun lowerp (c)
  ;; Warning: in EBCDIC, this kind of test for "alphabetic" is no
  ;; good. The letters are not contiguous.
  (and (integerp c) (<= ?a c) (<= c ?z)))

(defun upperp (c)
  ;; Warning: in EBCDIC, this kind of test for "alphabetic" is no
  ;; good. The letters are not contiguous.
  (and (integerp c) (<= ?A c) (<= c ?Z)))

(defun alphap (c)
  (or (lowerp c) (upperp c)))

(defun identifier-start-p (c)
  (and (integerp c) (or (alphap c) (= c ?_))))

(defun identifier-continuation-p (c)
  (and (integerp c) (or (alphap c) (= c ?_) (digitp c))))

(defun all-digits-p (thing)
  (cl-loop for c in thing
           if (not (digitp c)) return nil
           finally return t))

(defun list-to-string (lst)
  "Convert a list of characters to a string."
  (apply 'string lst))

(defun flatten (lst)
  "Flatten nested lists. (The implementation is recursive and not
for very long lists.)"
  (pcase lst
    ('() '())
    (`(,head . ,tail)
     (if (listp head)
         (append (flatten head) (flatten tail))
       (cons head (flatten tail))))))

(defun unexpected-character (line-no column-no c)
  (error (format "unexpected character '%c' at %d:%d"
                 c line-no column-no)))

(defun unsupported-escape (line-no column-no c)
  (error (format "unsupported escape \\%c at %d:%d"
                 c line-no column-no)))

(defun illegal-integer-literal (line-no column-no s)
  (error (format "illegal integer literal \"%s\" at %d:%d"
                 s line-no column-no)))

(defun unterminated-character-literal (line-no column-no)
  (error (format "unterminated character literal starting at %d:%d"
                 line-no column-no)))

(defun multicharacter-literal (line-no column-no)
  (error (format
          "unsupported multicharacter literal starting at %d:%d"
          line-no column-no)))

(defun end-of-input-in-string-literal (line-no column-no)
  (error (format "end of input in string literal starting at %d:%d"
                 line-no column-no)))

(defun end-of-line-in-string-literal (line-no column-no)
  (error (format "end of line in string literal starting at %d:%d"
                 line-no column-no)))

(defun unterminated-comment (line-no column-no)
  (error (format "unterminated comment starting at %d:%d"
                 line-no column-no)))

(defun main ()
  (setq inp (make-inp t))
  (scan-text t))

(main)
