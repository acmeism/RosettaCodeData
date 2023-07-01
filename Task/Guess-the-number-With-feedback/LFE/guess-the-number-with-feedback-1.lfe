(defmodule guessing-game
  (export (main 0)))

(defun get-player-guess ()
  (let (((tuple 'ok (list guessed)) (: io fread '"Guess number: " '"~d")))
    guessed))

(defun check-guess (answer guessed)
    (cond
      ((== answer guessed)
        (: io format '"Well-guessed!!~n"))
      ((/= answer guessed)
        (if (> answer guessed) (: io format '"Your guess is too low.~n"))
        (if (< answer guessed) (: io format '"Your guess is too high.~n"))
        (check-guess answer (get-player-guess)))))

(defun main ()
  (: io format '"Guess the number I have chosen, between 1 and 10.~n")
  (check-guess
    (: random uniform 10)
    (get-player-guess)))
