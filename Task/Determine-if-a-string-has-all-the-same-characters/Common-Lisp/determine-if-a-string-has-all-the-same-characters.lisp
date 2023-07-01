(defun strequ (&rest str)
    (if (not str) (setf str (list "" "   " "2" "333" ".55" "tttTTT" "4444 444k")))
    (dolist (s str)
        (do ((i 0 (1+ i)))
            ((cond
                ((= i (length s))
                    (format t "\"~a\" [~d] : All characters are identical.~%" s (length s)) t)
                ((char/= (char s i) (char s 0))
                    (format t "\"~a\" [~d] : '~c' (0x~0x) at index ~d is different.~%" s (length s) (char s i) (char-int (char s i)) i) t))))))
