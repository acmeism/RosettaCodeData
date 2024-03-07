(defun orderedp (word)
  (reduce (lambda (prev curr)
            (when (char> prev curr) (return-from orderedp nil))
            curr)
          word)
  t)

(defun longest-ordered-words (filename)
  (let ((result nil))
    (with-open-file (s filename)
      (loop
         with greatest-length = 0
         for word = (read-line s nil)
         until (null word)
         do (let ((length (length word)))
              (when (and (>= length greatest-length)
                         (orderedp word))
                (when (> length greatest-length)
                  (setf greatest-length length
                        result nil))
                (push word result)))))
    (nreverse result)))

CL-USER> (longest-ordered-words "unixdict.txt")
("abbott" "accent" "accept" "access" "accost" "almost" "bellow" "billow"
 "biopsy" "chilly" "choosy" "choppy" "effort" "floppy" "glossy" "knotty")
