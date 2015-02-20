#lang racket
(define states
  (list->set
   (map string-downcase
        '("Alabama" "Alaska" "Arizona" "Arkansas"
          "California" "Colorado" "Connecticut"
          "Delaware"
          "Florida" "Georgia" "Hawaii"
          "Idaho" "Illinois" "Indiana" "Iowa"
          "Kansas" "Kentucky" "Louisiana"
          "Maine" "Maryland" "Massachusetts" "Michigan"
          "Minnesota" "Mississippi" "Missouri" "Montana"
          "Nebraska""Nevada" "New Hampshire" "New Jersey"
          "New Mexico" "New York" "North Carolina" "North Dakota"
          "Ohio" "Oklahoma" "Oregon"
          "Pennsylvania" "Rhode Island"
          "South Carolina" "South Dakota" "Tennessee" "Texas"
          "Utah" "Vermont" "Virginia"
          "Washington" "West Virginia" "Wisconsin" "Wyoming"
          ; "New Kory" "Wen Kory" "York New" "Kory New" "New Kory"
          ))))

(define (canon s t)
  (sort (append (string->list s) (string->list t)) char<? ))

(define seen (make-hash))
(for* ([s1 states] [s2 states] #:when (string<? s1 s2))
  (define c (canon s1 s2))
  (cond [(hash-ref seen c (λ() (hash-set! seen c (list s1 s2)) #f))
         => (λ(states) (displayln (~v states (list s1 s2))))]))
