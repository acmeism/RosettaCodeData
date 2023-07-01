(defconstant +suits+
  '(club diamond heart spade)
  "Card suits are the symbols club, diamond, heart, and spade.")

(defconstant +pips+
  '(ace 2 3 4 5 6 7 8 9 10 jack queen king)
  "Card pips are the numbers 2 through 10, and the symbols ace, jack,
queen and king.")

(defun make-deck (&aux (deck '()))
  "Returns a list of cards, where each card is a cons whose car is a
suit and whose cdr is a pip."
  (dolist (suit +suits+ deck)
    (dolist (pip +pips+)
      (push (cons suit pip) deck))))

(defun shuffle (list)
  "Returns a shuffling of list, by sorting it with a random
predicate. List may be modified."
  (sort list #'(lambda (x y)
                 (declare (ignore x y))
                 (zerop (random 2)))))
