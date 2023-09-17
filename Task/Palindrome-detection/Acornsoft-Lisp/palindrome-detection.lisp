(defun palindrome-type (text)
  (cond ((exact-palindrom-p text)    'exact)
        ((inexact-palindrome-p text) 'inexact)
        (t 'not-a-palindrome)))

(defun exact-palindrom-p (text)
  (eq text (implode (reverse (explode text)))))

(defun inexact-palindrome-p (text)
  (exact-palindrom-p (implode (normalise (explode text)))))

(defun reverse (list (result . ()))
  (map '(lambda (e) (setq result (cons e result)))
       list)
  result)

(defun normalise (chars)
  (cond ((null chars)
         nil)
        ((not (alphanumeric-p (car chars)))
         (normalise (cdr chars)))
        ((upper-case-p (car chars))
         (cons (to-lower-case (car chars))
               (normalise (cdr chars))))
        (t
         (cons (car chars) (normalise (cdr chars))))))

(defun between-p (lowest-value n highest-value)
  (not (or (lessp n lowest-value)
           (greaterp n highest-value))))

(defun alphanumeric-p (ch)
  (or (lower-case-p ch) (upper-case-p ch) (digit-p ch)))

(defun digit-p (ch)
  (between-p (add1 (ordinal '/))
             (ordinal ch)
             (sub1 (ordinal ':))))

(defun upper-case-p (ch)
  (between-p (ordinal 'A) (ordinal ch) (ordinal 'Z)))

(defun lower-case-p (ch)
  (between-p (ordinal 'a) (ordinal ch) (ordinal 'z)))

(defun to-lower-case (ch)
  (character (plus (ordinal ch)
                   (difference (ordinal 'a) (ordinal 'A)))))

(defun examples ()
  (map '(lambda (text)
          (printc '!" text '!"
                  '! is!  (palindrome-type text)))
       '(a
         abba   Abba
         abcba
         baba
         Able! was! I! ere! I! saw! Elba!!
         In! girum! imus! nocte,! et! consumimur! igni)))
