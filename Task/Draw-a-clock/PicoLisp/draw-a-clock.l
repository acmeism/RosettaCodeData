(de draw Lst
   (for L Lst
      (for X L
         (cond
            ((num? X) (space X))
            ((sym? X) (prin X))
            (T (do (car X) (prin (cdr X)))) ) )
      (prinl) ) )

(de bigBox (N)
   (do 2
      (prin "|")
      (for I 4
         (prin (if (> I N) "          |" " ======== |")) )
      (prinl) ) )

(call 'clear)          # Clear screen
(call "tput" "civis")  # Set cursor invisible

(push '*Bye '(call "tput" "cnorm"))  # Set cursor visible on exit

(loop
   (call "tput" "cup" 0 0)  # Cursor to top left
   (let Time (time (time))
      (draw (20 (5 . _)) (19 / 5 \\))
      (if (onOff (NIL))
         (draw (18 / 7 \\) (18 \\ 7 /))
         (draw (18 / 2 (3 . "#") 2 \\) (18 \\ 2 (3 . "#") 2 /)) )
      (draw
         (19 \\ (5 . _) /)
         (+ (10 . -) + (10 . -) + (10 . -) + (10 . -) +) )
      (bigBox (/ (car Time) 5))
      (draw (+ (10 . -) + (10 . -) + (10 . -) + (10 . -) +))
      (bigBox (% (car Time) 5))
      (draw (+ (43 . -) +))
      (do 2
         (prin "|")
         (for I `(range 5 55 5)
            (prin
               (cond
                  ((> I (cadr Time)) "   |")
                  ((=0 (% I 3)) " # |")
                  (T " = |") ) ) )
         (prinl) )
      (draw (+ (43 . -) +))
      (bigBox (% (cadr Time) 5))
      (draw (+ (10 . -) + (10 . -) + (10 . -) + (10 . -) +)) )
   (wait 1000) )
