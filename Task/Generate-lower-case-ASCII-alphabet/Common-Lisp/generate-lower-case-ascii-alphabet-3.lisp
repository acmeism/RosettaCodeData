(assert (= 26 (length *lowercase-alphabet-string*) (length *lower*)))
(assert (every #'char< *lowercase-alphabet-string* (subseq *lowercase-alphabet-string* 1)))
(assert (apply #'char< *lower*))
(assert (string= *lowercase-alphabet-string* (coerce *lower* 'string)))
