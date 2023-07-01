(define eight-ball-responses
    (list "It is certain" "It is decidedly so" "Without a doubt" "Yes definitely" "You may rely on it"
          "As I see it, yes" "Most likely" "Outlook good" "Yes" "Signs point to yes"
          "Reply hazy try again" "Ask again later" "Better not tell you now" "Cannot predict now"
          "Concentrate and ask again"
          "Don't count on it" "My reply is no" "My sources say no" "Outlook not so good"
          "Very doubtful"))

(define ((answer-picker answers)) (sequence-ref answers (random (sequence-length answers))))

(define magic-eightball (answer-picker eight-ball-responses))

(module+ main
 (let loop ()
   (display "What do you want to know\n?")
   (read-line)
   (displayln (magic-eightball))
   (loop)))
