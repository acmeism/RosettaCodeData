(defun perfect-shuffle (deck)
  (let* ((half (floor (length deck) 2))
         (left (subseq deck 0 half))
         (right (nthcdr half deck)))
    (mapcan #'list left right)))

(defun solve (deck-size)
  (loop with original = (loop for n from 1 to deck-size collect n)
        for trials from 1
        for deck = original then shuffled
        for shuffled = (perfect-shuffle deck)
        until (equal shuffled original)
        finally (format t "~5D: ~4D~%" deck-size trials)))

(solve 8)
(solve 24)
(solve 52)
(solve 100)
(solve 1020)
(solve 1024)
(solve 10000)
