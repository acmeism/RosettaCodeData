(defun vowel-p (c &optional (vowels "aeiou"))
   (and (characterp c) (characterp (find c vowels :test #'char-equal))))

(defun count-vowels (s)
   (and (stringp s) (count-if #'vowel-p s)))

(defun count-consonants (s)
   (and (stringp s) (- (count-if #'alpha-char-p s) (count-vowels s))))
