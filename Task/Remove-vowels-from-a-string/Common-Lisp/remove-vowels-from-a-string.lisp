(defun vowel-p (c &optional (vowels "aeiou"))
   (and (characterp c) (characterp (find c vowels :test #'char-equal))))

(defun remove-vowels (s)
   (and (stringp s) (remove-if #'vowel-p s)))
