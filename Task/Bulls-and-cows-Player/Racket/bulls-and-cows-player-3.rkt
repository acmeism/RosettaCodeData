(printf "Playing Bulls & Cows with ~a unique digits\n" size)

(let loop ([choices all-choices] [num 1])
  (if (null? choices)
      (printf "Bad scoring! nothing fits those scores you gave.")
      (let ([guess (car choices)])
        #;(printf "(Narrowed to ~a possibilities)\n" (length choices))
        (printf "Guess #~a is ~a. Answer: Bulls, Cows? " num (listnum->string guess))
        (let-values ([(bulls cows) (parse-score (read-line))])
          ;parse-score returns (#f #f) on errors
          (if (and bulls cows)
              (begin
                (printf "Bulls: ~a, Cows: ~a\n" bulls cows)
                (if (and (= bulls size) (= cows 0))
                    (printf "Ye-haw!")
                    (let ()
                      (define (equal-score? chosen)
                        (let-values ([(c-bulls c-cows) (calculate-score guess chosen)])
                          (and (= c-bulls bulls) (= c-cows cows))))
                      (loop (filter equal-score? choices) (+ num 1)))))
              (begin
                (printf "Sorry, I didn't understand that. Please try again.\n")
                (loop choices num)))))))
