#lang racket

(define (get-tallies filename . patterns)
  (for/fold ([totals (build-list (length patterns) (λ (p) 0))])
    ([line (file->lines filename)])
    (let* ([words (string-split line)]
           [word (first words)]
           [n (or (string->number (last words)) 1)])
      (for/list ([p patterns] [t totals])
        (if (regexp-match? p word) (+ n t) t)))))

(define (plausible test) (string-append (if test "" "IM") "PLAUSIBLE"))

(define (subrule description examples counters)
  (let ([result (> examples (* 2 counters))])
    (printf "  The sub-rule \"~a\" is ~a.  There were ~a examples and ~a counter-examples.\n"
            description (plausible result) examples counters)
    result))

(define (plausibility description filename)
  (printf "~a:\n" description)
  (let-values ([(cei cie ie ei) (get-tallies filename)])
    (let ([rule1 (subrule "I before E when not preceded by C" (- ie cie) (- ei cei))]
          [rule2 (subrule "E before I when preceded by C" cei cie)])
      (printf "\n  Overall, the rule \"I before E, except after C\" is ~a.\n"
              (plausible (and rule1 rule2))))))

(plausibility "Dictionary" "unixdict.txt") (newline)
(plausibility "Word frequencies (stretch goal)" "1_2_all_freq.txt")
