#lang racket
(require (only-in srfi/13 [string-reverse gnirts]))

;; returns a string with the "comma"s inserted every step characters from the RIGHT of n.
;; because of the right handedness of this, there is a lot of reversal going on
(define ((insert-commas comma step) n)
  (define px (pregexp (format ".{1,~a}" step)))
  (string-join (add-between (reverse (map gnirts (regexp-match* px (gnirts n)))) comma) ""))

(define (commatize s #:start (start 0) #:comma (comma ",") #:step (step 3))
  (define ins-comms (insert-commas comma step)) ; specific to our comma and step

  (define split-into-numbers
    (match-lambda
      [(regexp
        #px"^([^1-9]*)([1-9][0-9.]*)(\\S*)(.*)$" ; see below for description of bits
        (list _                               ; the whole match
              (app split-into-numbers pre)    ; recur on left
              num                             ; the number bit before any exponent or other
                                              ; interestingness
              post-number                     ; from exponent to the first space
              (app split-into-numbers post))) ; recur on right
       (define skip (substring num 0 start))
       (match-define
         (regexp #px"^(.*?)(\\..*)?$"
                 (list _                      ; whole match
                       (app ins-comms n)      ; the bit that gets the commas added
                       (or (? string? d)      ; if it matches, then the raw string is in d
                           (and #f (app (lambda (f) "") d))))) ; if (...)? doesn't match it returns
                                                               ; #f which we thunk to an empty string
         (substring num start))                       ; do the match on the unskipped bit
       (string-append pre skip n d post-number post)] ; stitch it back together
      [else else]))                                   ; if it doesn't match leave as is

  ;; kick it off
  (split-into-numbers s))

(module+ test
  (require tests/eli-tester)

  (test
   (commatize "pi=3.14159265358979323846264338327950288419716939937510582097494459231"
              #:start 6 #:comma " " #:step 5)
   =>"pi=3.14159 26535 89793 23846 26433 83279 50288 41971 69399 37510 58209 74944 59231"

   (commatize "The author has two Z$100000000000000 Zimbabwe notes (100 trillion)." #:comma ".")
   =>"The author has two Z$100.000.000.000.000 Zimbabwe notes (100 trillion)."

   (commatize "-in Aus$+1411.8millions")
   =>"-in Aus$+1,411.8millions"

   (commatize "===US$0017440 millions=== (in 2000 dollars)")
   =>"===US$0017,440 millions=== (in 2,000 dollars)"

   (commatize "123.e8000 is pretty big.")
   =>"123.e8000 is pretty big."

   (commatize "The land area of the earth is  57268900(29% of the surface)  square miles.")
   =>"The land area of the earth is  57,268,900(29% of the surface)  square miles."

   (commatize "Ain't no numbers in this here words, nohow, no way, Jose.")
   =>"Ain't no numbers in this here words, nohow, no way, Jose."

   (commatize "James was never known as  0000000007")
   =>"James was never known as  0000000007"

   (commatize "Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe.")
   =>"Arthur Eddington wrote: I believe there are 15,747,724,136,275,002,577,605,653,961,181,555,468,044,717,914,527,116,709,366,231,425,076,185,631,031,296 protons in the universe."

   (commatize "   $-140000±100  millions.")

   =>"   $-140,000±100  millions."
   (commatize "6/9/1946 was a good year for some.")
   =>"6/9/1946 was a good year for some."))
