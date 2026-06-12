(defun print-words (file-name word-length vowels vowels-number)
   (with-open-file (dictionary file-name :if-does-not-exist nil)
      (loop for word = (read-line dictionary nil nil)
            while word
               when (and (> (length word) word-length)
                         (every #'(lambda (c)
                                     (= (count c word :test #'char-equal) vowels-number))
                                  vowels)) do
                  (write-line word))))

(print-words "unixdict.txt" 10 "aeiou" 1)
