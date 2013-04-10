(de ok? (N)
   (let D (mapcar 'format (chop N))
      (and (num? N)
           (not (member 0 D))
           (= 4 (length D))
           (= D (uniq D))
           D )) )

(de init-cows ()
   (until (setq *Hidden (ok? (rand 1234 9876)))) )

(de guess (N)
   (let D (ok? N)
      (if D
         (let Bulls (cnt '= D *Hidden)
            (if (= 4 Bulls)
               " You guessed it!"
               (let Cows (- (cnt '((N) (member N *Hidden)) D) Bulls)
                  (pack Bulls " bulls, " Cows " cows") ) ) )
         " Bad guess! (4 unique digits, 1-9)" ) ) )
