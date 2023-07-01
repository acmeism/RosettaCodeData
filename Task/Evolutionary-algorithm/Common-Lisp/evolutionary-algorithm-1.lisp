(defun fitness (string target)
  "Closeness of string to target; lower number is better"
  (loop for c1 across string
        for c2 across target
        count (char/= c1 c2)))

(defun mutate (string chars p)
  "Mutate each character of string with probablity p using characters from chars"
  (dotimes (n (length string))
    (when (< (random 1.0) p)
      (setf (aref string n) (aref chars (random (length chars))))))
  string)

(defun random-string (chars length)
  "Generate a new random string consisting of letters from char and specified length"
  (do ((n 0 (1+ n))
       (str (make-string length)))
      ((= n length) str)
    (setf (aref str n) (aref chars (random (length chars))))))

(defun evolve-string (target string chars c p)
  "Generate new mutant strings, and choose the most fit string"
  (let ((mutated-strs (list string)))
    (dotimes (n c)
      (push (mutate (copy-seq string) chars p) mutated-strs))
    (reduce #'(lambda (s0 s1)
                (if (< (fitness s0 target)
                       (fitness s1 target))
                    s0
                    s1))
            mutated-strs)))

(defun evolve-gens (target c p)
  (let ((chars " ABCDEFGHIJKLMNOPQRSTUVWXYZ"))
    (do ((parent (random-string chars (length target))
                 (evolve-string target parent chars c p))
         (n 0 (1+ n)))
        ((string= target parent) (format t "Generation ~A: ~S~%" n parent))
      (format t "Generation ~A: ~S~%" n parent))))
