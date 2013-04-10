(defun anagrams (&optional (url "http://www.puzzlers.org/pub/wordlists/unixdict.txt"))
  (let ((words (drakma:http-request url :want-stream t))
        (wordsets (make-hash-table :test 'equalp)))
    ;; populate the wordsets and close stream
    (do ((word (read-line words nil nil) (read-line words nil nil)))
        ((null word) (close words))
      (let ((letters (sort (copy-seq word) 'char<)))
        (multiple-value-bind (pair presentp)
            (gethash letters wordsets)
          (if presentp
           (setf (car pair) (1+ (car pair))
                 (cdr pair) (cons word (cdr pair)))
           (setf (gethash letters wordsets)
                 (cons 1 (list word)))))))
    ;; find and return the biggest wordsets
    (loop with maxcount = 0 with maxwordsets = '()
          for pair being each hash-value of wordsets
          if (> (car pair) maxcount)
          do (setf maxcount (car pair)
                   maxwordsets (list (cdr pair)))
          else if (eql (car pair) maxcount)
          do (push (cdr pair) maxwordsets)
          finally (return (values maxwordsets maxcount)))))
