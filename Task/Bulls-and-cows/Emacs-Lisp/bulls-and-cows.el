(defun get-list-4-random-digits ()
  "Generate a list of 4 random non-repeating digits."
  (let ((list-of-digits '(0 1 2 3 4 5 6 7 8 9))
        (one-digit)
        (four-digits))
    (dotimes (n 4)
      (setq one-digit (seq-random-elt list-of-digits))
      (push one-digit four-digits)
      (setq list-of-digits (delq one-digit (copy-sequence list-of-digits))))
    four-digits))

(defun list-digits (guess-string)
  "List individual digits of GUESS-STRING."
  (let ((list-of-digits)
        (one-digit)
        (total-digits (length guess-string)))
    (dotimes (n total-digits)
      (setq one-digit (string-to-number (substring guess-string n (1+ n))))
      (push one-digit list-of-digits))
    (reverse list-of-digits)))

(defun number-list-to-string (numbers)
  (mapconcat #'number-to-string numbers))

(defun four-non-repeating-digits-p (guess-string)
  "Test if GUESS-STRING has 4 one-digit numbers that do not repeat."
  ;; if GUESS-STRING contains non-numeric characters, then
  ;; the non-numeric characters will be converted to 0s
  (let ((number-list (list-digits guess-string)))

    (and
     ;; GUESS-STRING must consist of exactly 4 digits
     (string-match-p "^[[:digit:]]\\{4\\}$" guess-string)

       ;; the length of the list must still be 4 after
       ;; removing duplicate characters, and
     (= (length (seq-uniq number-list)) 4))))

(defun count-bulls (guess answer)
  "Count number of bulls in GUESS as compared to ANSWER.
In this game, a bull is an exact match. Both GUESS and
ANSWER are lists of numbers."
  (let ((bulls 0)
        (position-in-list -1))
    (dolist (guess-number guess)
      (setq position-in-list (1+ position-in-list))
      (when (= guess-number (nth position-in-list answer))
        (setq bulls (1+ bulls))))
    bulls))

(defun is-cow-p (number-list position answer)
  "Test if NUMBER-LIST is in ANSWER but not in same POSITION."
      (and
       ;; NUMBER-LIST is found in ANSWER
       (seq-position answer number-list)
       ;; NUMBER-LIST is not in same POSITION in ANSWER
       (not (equal number-list (nth position answer)))))

(defun count-cows (guess answer)
  "Count number of cows in GUESS as compared to ANSWER.
In this game, a cow is a match, but only in a different position.
Both GUESS and ANSWER are lists of numbers."
  (let ((cows 0)
        (zero-based-position 0))
    (dotimes (n 4)
      (when (is-cow-p (nth zero-based-position guess) zero-based-position answer)
        (setq cows (1+ cows)))
      (setq zero-based-position (1+ zero-based-position)))
    cows))

(defun count-bulls-and-cows (guess answer count)
  "Give game feedback for GUESS as compared to ANSWER."
  (let ((cows (count-cows guess answer))
        (bulls (count-bulls guess answer)))
    (goto-char (point-max))
    (insert (format  "\n%3s -  %s         Bulls = %s  Cows = %s" count (number-list-to-string guess)  bulls  cows))
    (when (= bulls 4)
      (insert "  You win!")
      t)))

(defun get-player-guess ()
  "Get player guess."
  (let ((player-guess))
    (setq player-guess (read-string "Enter a 4 digit number or Q to quit: "))
    player-guess))

(defun play-bulls-and-cows ()
  "Play bulls and cows game."
  (interactive)
  (let ((answer (get-list-4-random-digits))
        (player-guess-string)
        (player-guess-list-of-numbers)
        (count 0))
    (with-current-buffer (pop-to-buffer "bulls and cows game")
      (erase-buffer)
      (insert (propertize
       (concat
         "Rules: Enter a 4 digit number whose digits do not repeat."
         "\n   For example, 2468 is 4 digit number with non-repeating digits."
         "\n   Digits that match both the number and position will be scored as bulls."
         "\n   Digits that match the number but *not* the position will be scored as cows.") 'face 'shadow))

      ;; (insert "Rules: Enter a 4 digit number whose digits do not repeat.")
      ;; (insert "\n   For example, 2468 is 4 digit number with non-repeating digits.")
      ;; (insert "\n   Digits that match both the number and position will be scored as bulls.")
      ;; (insert "\n   Digits that match the number but *not* the position will be scored as cows.")
      (insert (propertize
               (concat
                "\n"
                "\nTurn   Your guess   Result"
                "\n----   ----------   ------")
               'face 'bold))
      (catch 'end-game
        (while t
            (progn
              ;; get input
              (setq player-guess-string (get-player-guess))
              (setq player-guess-list-of-numbers (list-digits player-guess-string))
              ;; evaluate input
              (cond
               ((string-equal-ignore-case player-guess-string "Q")
                (insert "\nGame ended because Q was entered")
                (throw 'end-game t))
               ((four-non-repeating-digits-p player-guess-string)
                ;; increase count of turns played by 1
                (setq count (1+ count))
                ;; count-bulls-and-cows returns nil if 4 bulls
                (and (count-bulls-and-cows player-guess-list-of-numbers answer count)
                     (throw 'end-game t)))
               (t
                (goto-char (point-max))
                (insert (propertize (format "\nThe guess entered was %S\nYou must enter a number with 4 non-repeating digits or Q to quit." player-guess-string) 'face 'error))))))))))
