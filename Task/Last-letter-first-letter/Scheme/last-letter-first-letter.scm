(use srfi-13)  ;; for string-take

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

(define words
  (map
    (lambda (str)
      (vector
        (string->symbol (string-take str 1))
        (string->symbol (string-take-right str 1))
        str))
    (string-split names char-whitespace? 'prefix)))

(define (find-longest prev-last words)
  (let ((best '())  (long #f))
    (dolist (w words)
      (when (or (not prev-last)
                (eq? prev-last (vector-ref w 0)))
        (set! long
          (cons w (find-longest (vector-ref w 1) (delete w words))))
        (when (> (length long) (length best)) (set! best long))))
    best))

(define longest (find-longest #f words))

(begin
  (print "Length of solution: " (length longest))
  (dotimes (i (length longest))
    (display (format "~12a" (vector-ref (list-ref longest i) 2)))
    (when (zero? (mod (+ 1 i) 5)) (newline)))
  (newline))

Length of solution: 23
machamp     petilil     landorus    scrafty     yamask
kricketune  emboar      registeel   loudred     darmanitan
nosepass    simisear    relicanth   heatmor     rufflet
trapinch    haxorus     seaking     girafarig   gabite
exeggcute   emolga      audino
