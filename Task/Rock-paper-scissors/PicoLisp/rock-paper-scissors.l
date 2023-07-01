(use (C Mine Your)
   (let (Rock 0  Paper 0  Scissors 0)
      (loop
         (setq Mine
            (let N (if (gt0 (+ Rock Paper Scissors)) (rand 1 @) 0)
               (seek
                  '((L) (le0 (dec 'N (caar L))))
                  '(Rock Paper Scissors .) ) ) )
         (prin "Enter R, P or S to play, or Q to quit: ")
         (loop
            (and (= "Q" (prinl (setq C (uppc (key))))) (bye))
            (T (setq Your (find '((S) (pre? C S)) '(Rock Paper Scissors))))
            (prinl "Bad input - try again") )
         (prinl
            "I say " (cadr Mine) ", You say " Your ": "
            (cond
               ((== Your (cadr Mine)) "Draw")
               ((== Your (car Mine)) "I win")
               (T "You win") ) )
         (inc Your) ) ) )
