#lang racket

(define names "
  audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon
  cresselia croagunk darmanitan deino emboar emolga exeggcute gabite girafarig
  gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan
  kricketune landorus ledyba loudred lumineon lunatone machamp magnezone
  mamoswine nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena
  porygon2 porygonz registeel relicanth remoraid rufflet sableye scolipede
  scrafty seaking sealeo silcoon simisear snivy snorlax spoink starly tirtouga
  trapinch treecko tyrogue vigoroth vulpix wailord wartortle whismur wingull
  yamask")

(struct word (first last string) #:prefab)
(define words
  (for/list ([str (string-split names)])
    (word (string->symbol (substring str 0 1))
          (string->symbol (substring str (sub1 (string-length str))))
          str)))

(define (find-longest last words)
  (for/fold ([best '()])
            ([w (in-list words)]
             #:when (or (not last) (eq? last (word-first w))))
    (define long (cons w (find-longest (word-last w) (remq w words))))
    (if (> (length long) (length best)) long best)))

(define longest (find-longest #f words))
(printf "Longest chain found has ~a words:\n  ~a\n"
        (length longest) (string-join (map word-string longest) " -> "))
