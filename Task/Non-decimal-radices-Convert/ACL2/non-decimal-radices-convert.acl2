(defun digit-value (chr)
   (cond ((and (char>= chr #\0)
               (char<= chr #\9))
          (- (char-code chr) (char-code #\0)))
         ((and (char>= chr #\A)
               (char<= chr #\Z))
          (+ (- (char-code chr) (char-code #\A)) 10))
         ((and (char>= chr #\a)
               (char<= chr #\z))
          (+ (- (char-code chr) (char-code #\a)) 10))))

(defun value-digit (n)
   (if (< n 10)
       (code-char (+ n (char-code #\0)))
       (code-char (+ (- n 10) (char-code #\A)))))

(defun num-from-cs (cs base)
   (if (endp cs)
       0
       (+ (digit-value (first cs))
          (* base (num-from-cs (rest cs) base)))))

(defun parse-num (str base)
   (num-from-cs (reverse (coerce str 'list)) base))

(include-book "arithmetic-3/top" :dir :system)

(defun num-to-cs (num base)
   (if (or (zp num) (zp base) (= base 1))
       nil
       (cons (value-digit (mod num base))
             (num-to-cs (floor num base) base))))

(defun show-num (num base)
   (coerce (reverse (num-to-cs num base)) 'string))
