(defun nshuffle (sequence)
  (loop for i from (length sequence) downto 2
        do (rotatef (elt sequence (random i))
                    (elt sequence (1- i ))))
  sequence)

(defun sortedp (list predicate)
  (every predicate list (rest list)))

(defun bogosort (list predicate)
  (do ((list list (nshuffle list)))
      ((sortedp list predicate) list)))
