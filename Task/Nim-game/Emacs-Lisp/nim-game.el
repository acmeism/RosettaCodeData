(defun report-move (player selection remainder)
  "Report PLAYER SELECTION and REMAINDER of stones for move."
  (let ((stones-selected "stones")
        (stones-remaining "stones remaining"))
    (when (= selection 1)
      (setq stones-selected "stone"))
    (when (= remainder 1)
      (setq stones-remaining "stone remaining"))
  (goto-char (point-max))
  (insert (format "\n%s %d %s. %d %s." player selection stones-selected remainder stones-remaining))))

(defun decide-computer-move (human-move)
  "Return the computer move based on HUMAN-MOVE."
  (- 4 human-move))

(defun get-human-move ()
  "Get the human move."
  (read-number "How many tokens will you take? Enter a number 1-3: "))

(defun valid-nim-move-p (move)
  "Test if valid nim move."
  (and (>= move 1)
       (<= move 3)))

(defun play-nim ()
  "Play the game of nim."
  (let ((tokens 12)
        (player-pick-number)
        (computer-pick-number))
    (with-current-buffer (pop-to-buffer "Game of Nim")
      (erase-buffer)
      (insert (format "Welcome to the game of Nim!\n\n"))
      (catch 'end-game
        (while (> tokens 0)
          (progn
            ;; get input
            (setq player-pick-number (get-human-move))
            ;; evaluate input
            (cond
             ((valid-nim-move-p player-pick-number)
              (setq tokens (- tokens player-pick-number))
              (report-move "You take" player-pick-number tokens)
              ;; get computer move
              (setq computer-pick-number (decide-computer-move player-pick-number))
              (setq tokens (- tokens computer-pick-number))
              (sit-for 1)
              (report-move "Computer takes" computer-pick-number tokens)
              (when (<= tokens 0)
                (insert (format "\n\nThe computer wins!"))
                (throw 'end-game t)))
             (t
              (goto-char (point-max))
              (insert (propertize (format "\nThe amount entered was %d\nYou must enter either a 1, 2, or 3 only." player-pick-number) 'face 'error))))))))))

