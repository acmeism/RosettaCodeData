;; available preloaded sounds are : ok, ko, tick, tack, woosh, beep, digit .
(lib 'timer)

(define (metronome) (blink) (play-sound 'tack))
(at-every 1000 'metronome) ;; every 1000 msec
;; CTRL-C to stop
