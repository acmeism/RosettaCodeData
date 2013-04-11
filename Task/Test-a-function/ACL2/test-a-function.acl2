(defun reverse-split-at-r (xs i ys)
  (if (zp i)
      (mv xs ys)
      (reverse-split-at-r (rest xs) (1- i)
                          (cons (first xs) ys))))

(defun reverse-split-at (xs i)
  (reverse-split-at-r xs i nil))

(defun is-palindrome (str)
  (let* ((lngth (length str))
         (idx (floor lngth 2)))
    (mv-let (xs ys)
            (reverse-split-at (coerce str 'list) idx)
            (if (= (mod lngth 2) 1)
                (equal (rest xs) ys)
                (equal xs ys)))))

(include-book "testing" :dir :teachpacks)

(check-expect (is-palindrome "abba") t)
(check-expect (is-palindrome "mom") t)
(check-expect (is-palindrome "dennis sinned") t)
(check-expect (is-palindrome "palindrome") nil)
(check-expect (is-palindrome "racecars") nil)

(include-book "doublecheck" :dir :teachpacks)

(defrandom random-palindrome ()
  (let ((chars (random-list-of (random-char))))
    (coerce (append chars (reverse chars))
            'string)))

(defproperty palindrome-test
  (p :value (random-palindrome))
  (is-palindrome p))
